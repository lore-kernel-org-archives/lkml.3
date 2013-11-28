Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3K1Lsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:48:46 -0500
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:34927 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3K1Lso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:48:44 -0500
MIME-Version: 1.0
In-Reply-To: <20131127121908.GE3296@lee--X1>
References: <1385036008-1727-1-git-send-email-ruslan.ruslichenko@globallogic.com>
	<20131127121908.GE3296@lee--X1>
Date: Thu, 28 Nov 2013 13:48:43 +0200
Message-ID: <CAK9oHmwe3TZZ+Ee=uymVk8oWbBD6Jq_9cgYXO3DUy67DPrRVJw@mail.gmail.com>
Subject: Re: [PATCH] mfd: twl-core: Clean up module by removing twl603x pdata handling
From: Ruslan Ruslichenko <ruslan.ruslichenko@globallogic.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Graeme Gregory <graeme.gregory@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On Wed, Nov 27, 2013 at 2:19 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 21 Nov 2013, Ruslan Ruslichenko wrote:
>
>> Since currently nobody uses TWL603x platform data and all new
>
> Hmm... when you say nobody, how did you come to this conclusion?
>
> Without digging into it and probably not that relevant, it
> appears there is some references to it in platform data still:
>
> $ git grep twl603 -- arch/ | grep -v dts
> arch/arm/mach-omap2/common.h:extern int omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers);
> arch/arm/mach-omap2/omap4-common.c:static int omap4_twl6030_hsmmc_late_init(struct device *dev)
> arch/arm/mach-omap2/omap4-common.c:             irq = twl6030_mmc_card_detect_config();
> arch/arm/mach-omap2/omap4-common.c:             pdata->slots[0].card_detect = twl6030_mmc_card_detect;
> arch/arm/mach-omap2/omap4-common.c:static __init void omap4_twl6030_hsmmc_set_late_init(struct device *dev)
> arch/arm/mach-omap2/omap4-common.c:     pdata->init =   omap4_twl6030_hsmmc_late_init;
> arch/arm/mach-omap2/omap4-common.c:int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
> arch/arm/mach-omap2/omap4-common.c:             omap4_twl6030_hsmmc_set_late_init(&c->pdev->dev);
> arch/arm/mach-omap2/omap4-common.c:int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
> arch/arm/mach-omap2/omap_twl.c:static unsigned long twl6030_vsel_to_uv(const u8 vsel)
> arch/arm/mach-omap2/omap_twl.c:static u8 twl6030_uv_to_vsel(unsigned long uv)
> arch/arm/mach-omap2/omap_twl.c: if (uv > twl6030_vsel_to_uv(0x39)) {
> arch/arm/mach-omap2/omap_twl.c:                 __func__, uv, twl6030_vsel_to_uv(0x39));
> arch/arm/mach-omap2/omap_twl.c: .vsel_to_uv             = twl6030_vsel_to_uv,
> arch/arm/mach-omap2/omap_twl.c: .uv_to_vsel             = twl6030_uv_to_vsel,
> arch/arm/mach-omap2/omap_twl.c: .vsel_to_uv             = twl6030_vsel_to_uv,
> arch/arm/mach-omap2/omap_twl.c: .uv_to_vsel             = twl6030_uv_to_vsel,
> arch/arm/mach-omap2/omap_twl.c: .vsel_to_uv             = twl6030_vsel_to_uv,
> arch/arm/mach-omap2/omap_twl.c: .uv_to_vsel             = twl6030_uv_to_vsel,
>

Looks like some misunderstanding is here. This patch *only* removes
platform data for TWL603x
which were used to create TWL sub-devices like regulators, adc's,
watchdogs, etc.
Previously it was set up in twl_common.c by omap4_pmic_init(), which
was called from board files
with specific pmic config.
Since now in Linux kernel 3.13 OMAP4 non-DT boot is not supported and
all OMAP4 board files
have been removed omap4_pmic_init() is never called and all TWL603x
sub-devices are created
from device tree data.

>> users will supply it through device tree, handling of these
>> data within twl-core will never be used, so remove it.
>>
>> Signed-off-by: Ruslan Ruslichenko <ruslan.ruslichenko@globallogic.com>
>> ---
>>
>> [...]


-- 
Regards,
Ruslan Ruslichenko | Software Engineer
GlobalLogic
www.globallogic.com

http://www.globallogic.com/email_disclaimer.txt
