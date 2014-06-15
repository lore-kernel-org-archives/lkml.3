Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaFOPAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 11:00:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51101 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750989AbaFOPAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 11:00:47 -0400
Message-ID: <539DB51D.5080204@free-electrons.com>
Date: Sun, 15 Jun 2014 17:00:45 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: jjhiblot@traphandler.com, Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 3/7] drm: add Atmel HLCDC Display Controller support
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-4-git-send-email-boris.brezillon@free-electrons.com> <539D6839.1070703@traphandler.com>
In-Reply-To: <539D6839.1070703@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello JJ,

On 15/06/2014 11:32, Jean-Jacques Hiblot wrote:
>
> On 06/09/2014 06:04 PM, Boris BREZILLON wrote:
>> The Atmel HLCDC (High LCD Controller) IP available on some Atmel SoCs (i.e.
>> at91sam9n12, at91sam9x5 family or sama5d3 family) provides a display
>> controller device.
>>
>> This display controller support at least one primary plane and might
>> provide several overlays and an hardware cursor depending on the IP
>> version.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---

[...]

>> +	    vm.vfront_porch > 0x40 || vm.vfront_porch < 0 ||
>> +	    vm.vback_porch > 0x40 || vm.vback_porch < 0 ||
>> +	    vm.hfront_porch > 0x200 || vm.hfront_porch < 0 ||
>> +	    vm.hback_porch > 0x200 || vm.hback_porch < 0 ||
>> +	    mode->hdisplay > 2048 || mode->hdisplay < 0 ||
>> +	    mode->vdisplay > 2048 || mode->vdisplay < 0)
>> +		return -EINVAL;
>> +
>> +	regmap_write(regmap, ATMEL_HLCDC_CFG(1),
>> +		     (vm.hsync_len - 1) | ((vm.vsync_len - 1) << 16));
>> +
>> +	regmap_write(regmap, ATMEL_HLCDC_CFG(2),
>> +		     (vm.vfront_porch - 1) | ((vm.vback_porch - 1) << 16));
> Acording to the datasheet, it's vm.vback_porch instead of
> (vm.vback_porch -1).

Oh, nice catch!

I'll check with Atmel that this is not a typo in their datasheet,
because all other fields need the minus 1.

Thanks for your review.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

