Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab3K2RKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:10:21 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17852 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3K2RKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:10:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JVMRgr/kuCz2sh0pyVj/1
Date: Fri, 29 Nov 2013 09:10:14 -0800
From: Tony Lindgren <tony@atomide.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Ruslan Ruslichenko <ruslan.ruslichenko@globallogic.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [PATCH] mfd: twl-core: Clean up module by removing twl603x
 pdata handling
Message-ID: <20131129171013.GM31534@atomide.com>
References: <1385036008-1727-1-git-send-email-ruslan.ruslichenko@globallogic.com>
 <20131127121908.GE3296@lee--X1>
 <CAK9oHmyq3wOwgzxPYOLjoHuHahPFJE=vEN+GZCzfu-ZFhk9_Hw@mail.gmail.com>
 <20131129091644.GB26086@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129091644.GB26086@lee--X1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lee Jones <lee.jones@linaro.org> [131129 01:17]:
> Attn: Tony
> 
> > > > Since currently nobody uses TWL603x platform data and all new
> > >
> > > Hmm... when you say nobody, how did you come to this conclusion?
> > >
> > > Without digging into it and probably not that relevant, it
> > > appears there is some references to it in platform data still:
> > >
> > > $ git grep twl603 -- arch/ | grep -v dts
> > > arch/arm/mach-omap2/common.h:extern int omap4_twl6030_hsmmc_init(struct
> > > omap2_hsmmc_info *controllers);
> > > arch/arm/mach-omap2/omap4-common.c:static int
> > > omap4_twl6030_hsmmc_late_init(struct device *dev)
> > > arch/arm/mach-omap2/omap4-common.c:             irq =
> > > twl6030_mmc_card_detect_config();
> > > arch/arm/mach-omap2/omap4-common.c:
> > > pdata->slots[0].card_detect = twl6030_mmc_card_detect;
> > > arch/arm/mach-omap2/omap4-common.c:static __init void
> > > omap4_twl6030_hsmmc_set_late_init(struct device *dev)
> > > arch/arm/mach-omap2/omap4-common.c:     pdata->init =
> > > omap4_twl6030_hsmmc_late_init;
> > > arch/arm/mach-omap2/omap4-common.c:int __init
> > > omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
> > > arch/arm/mach-omap2/omap4-common.c:
> > > omap4_twl6030_hsmmc_set_late_init(&c->pdev->dev);
> > > arch/arm/mach-omap2/omap4-common.c:int __init
> > > omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
> > > arch/arm/mach-omap2/omap_twl.c:static unsigned long
> > > twl6030_vsel_to_uv(const u8 vsel)
> > > arch/arm/mach-omap2/omap_twl.c:static u8 twl6030_uv_to_vsel(unsigned long
> > > uv)
> > > arch/arm/mach-omap2/omap_twl.c: if (uv > twl6030_vsel_to_uv(0x39)) {
> > > arch/arm/mach-omap2/omap_twl.c:                 __func__, uv,
> > > twl6030_vsel_to_uv(0x39));
> > > arch/arm/mach-omap2/omap_twl.c: .vsel_to_uv             =
> > > twl6030_vsel_to_uv,
> > > arch/arm/mach-omap2/omap_twl.c: .uv_to_vsel             =
> > > twl6030_uv_to_vsel,
> > > arch/arm/mach-omap2/omap_twl.c: .vsel_to_uv             =
> > > twl6030_vsel_to_uv,
> > > arch/arm/mach-omap2/omap_twl.c: .uv_to_vsel             =
> > > twl6030_uv_to_vsel,
> > > arch/arm/mach-omap2/omap_twl.c: .vsel_to_uv             =
> > > twl6030_vsel_to_uv,
> > > arch/arm/mach-omap2/omap_twl.c: .uv_to_vsel             =
> > > twl6030_uv_to_vsel,
> > >
> > Looks like some misunderstanding is here. This patch *only* removes
> > platform data for TWL603x
> > which were used to create TWL sub-devices like regulators, adc's,
> > watchdogs, etc.
> > Previously it was set up in twl_common.c by omap4_pmic_init(), which was
> > called from board files
> > with specific pmic config.
> > Since now in Linux kernel 3.13 OMAP4 non-DT boot is not supported and all
> > OMAP4 board files
> > have been removed omap4_pmic_init() is never called and all TWL603x
> > sub-devices are created
> > from device tree data.
> 
> I'm not overly familiar with this driver (it looks like a big
> historical mess to me), or the current state of the OMAP4 platform, so
> I would like a second opinion on this.
> 
> Tony would you be kind enough to oblige?

We've moved omap4 to boot based on device tree only, so that legacy
platform data is no longer being used. It might be worth checking if
we do have bindings in place for all of that, or if some of it may
still be needed to be passed as auxdata while we wait for the bindings.

Regards,

Tony
