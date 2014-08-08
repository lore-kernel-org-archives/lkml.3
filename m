Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaHHMiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:38:24 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36040 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaHHMiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:38:21 -0400
Message-ID: <53E4C4B5.2000202@collabora.co.uk>
Date: Fri, 08 Aug 2014 14:38:13 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] mfd: max77686: fix support for devices without irq specified
References: <1457999.lNPdqEWCCR@amdc1032> <1407495251.28710.2.camel@AMDC1943> <53E4AD6A.4000705@collabora.co.uk> <6204488.MKXsGQj0V8@amdc1032>
In-Reply-To: <6204488.MKXsGQj0V8@amdc1032>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 02:24 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> It seems that Daniel Drake has already fixed ODROID dtsi with:
> 
>   [PATCH 1/2] ARM: dts: Enable PMIC interrupts on ODROID
>   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34191.html
> 
> and
> 
>   [PATCH 2/2] ARM: dts: ODROID i2c improvements
>   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34190.html
> 
> Both patches are needed to fix boot on ODROID.  They also fix RTC driver
> registration:
> 
> MFD driver error message with only patch #1 applied:
> [    0.164488] max77686 0-0009: failed to add RTC irq chip: -6
> 
> RTC driver messages with both patches #1 and #2 applied:
> [    1.731461] max77686-rtc max77686-rtc: max77686_rtc_probe
> [    1.833303] max77686-rtc max77686-rtc: rtc core: registered max77686-rtc as rtc0
>

Great!

> Kukjin, could you please apply Daniel's fixes?  They are critical for ODROID
> boards.
> 
> Javier, I think that it still would be useful to apply my patch for max77686
> as it makes new kernels work with older dtbs and leaves the possibility to
> use PMIC on boards without IRQ connected.  If you agree I will post v2 of
> the patch (with suspend/resume handlers fixed and bindings documentation
> updated).
> 

Well it really depends on whether it is possible or not to have a design where a
IRQ line is not connected to the PMIC. If such a design makes sense then your
patch should be applied since the driver should not fail to probe in that case.

But then the DT binding doc should be changed and the "interrupt" property moved
from required to optional in order to reflect that it's not a requirement.

If the motivation is just to support old DTB then I tend to disagree since those
DTBs were not following the documented binding. Drivers should be robust enough
to not crash of course but if a required property is not defined in a DTB but
failing to probe is the right thing to do IMHO.

Best regards,
Javier


