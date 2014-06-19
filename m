Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbaFSHy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:54:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57848 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887AbaFSHyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:54:25 -0400
Message-ID: <53A2972E.60202@free-electrons.com>
Date: Thu, 19 Jun 2014 09:54:22 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 7/7] ARM: at91/dt: enable the LCD panel on sama5d3xek
 boards
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-8-git-send-email-boris.brezillon@free-electrons.com> <53A28D49.2040400@atmel.com>
In-Reply-To: <53A28D49.2040400@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19/06/2014 09:12, Bo Shen wrote:
> Hi Boris,
>
> On 06/10/2014 12:04 AM, Boris BREZILLON wrote:
>> diff --git a/arch/arm/boot/dts/sama5d33ek.dts
>> b/arch/arm/boot/dts/sama5d33ek.dts
>> index cbd6a3f..f2ab41d 100644
>> --- a/arch/arm/boot/dts/sama5d33ek.dts
>> +++ b/arch/arm/boot/dts/sama5d33ek.dts
>> @@ -36,9 +36,33 @@
>>               macb0: ethernet@f0028000 {
>>                   status = "okay";
>>               };
>> +
>> +            hlcdc: hlcdc@f0030000 {
>> +                status = "okay";
>> +
>> +                hlcdc-display-controller {
>> +                    atmel,panel = <&panel 3 0>;
>
> One question here, in the driver code, it will configuration the frame
> buffer mode depends on this parameter.
> So, my question is if the framebuffer bits per pixel is different with
> output bits per pixel, how to setting it?
>
> For example, frame buffer use 16 bits/pixel, while output 24 bits/pixel.

Actually the HLCDC is responsible for converting input format (either
RGB or YUV) to output format (one of the four supported RGB formats).

AFAICT, the HLCDC always converts the input format in RGB888 and then
only use the relevant bits (i.e. if the output is RGB565, it will only
takes MSB for each color).

The REP field (available in all layer, e.g. LCDC_BASECFG4 for the base
layer) is here to tell how the HLCDC should expand to 24 bits format.

All this means that we don't have to bother about input to output format
conversion.

>
>> +                };
>> +            };
>>           };
>>       };
>>
>
> Best Regards,
> Bo Shen

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

