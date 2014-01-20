Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaATJPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:15:06 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39006 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaATJPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:15:02 -0500
Message-ID: <52DCE8E9.1040304@ti.com>
Date: Mon, 20 Jan 2014 11:14:17 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <balbi@ti.com>,
        <sre@debian.org>, <mark.rutland@arm.com>,
        <m.paolino@virtualopensystems.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v5 2/9] mfd: omap-usb-host: Get clocks based on hardware
 revision
References: <1389269303-30465-1-git-send-email-rogerq@ti.com> <1389269303-30465-3-git-send-email-rogerq@ti.com> <20140110102251.GH28141@lee--X1> <201401101513.40470.arnd@arndb.de> <20140110142640.GA32035@lee--X1>
In-Reply-To: <20140110142640.GA32035@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 04:26 PM, Lee Jones wrote:
> On Fri, 10 Jan 2014, Arnd Bergmann wrote:
> 
>> On Friday 10 January 2014, Lee Jones wrote:
>>>>  
>>>> -     need_logic_fck = false;
>>>> +     /* Set all clocks as invalid to begin with */
>>>> +     omap->ehci_logic_fck = omap->init_60m_fclk = ERR_PTR(-EINVAL);
>>>> +     omap->utmi_p1_gfclk = omap->utmi_p2_gfclk = ERR_PTR(-EINVAL);
>>>> +     omap->xclk60mhsp1_ck = omap->xclk60mhsp2_ck = ERR_PTR(-EINVAL);
>>>
>>> I don't think this is the correct error code.
>>>
>>> -EINVAL means 'invalid parameter'.
>>>
>>> You probably want -ENODEV or -ENOSYS ('function not implemented'
>>> probably isn't ideal either tbh, but you get the idea). Perhaps you
>>> can set them as NULL and check for IS_ERR_OR_NULL() instead?
>>
>> I think ENODEV is ok here, I'd much prefer this over IS_ERR_OR_NULL().
> 
> Sounds good to me.
> 
OK. Will fix.

cheers,
-roger
