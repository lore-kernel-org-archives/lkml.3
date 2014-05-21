Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaEUTpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:45:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24015 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaEUTpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:45:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18tTGz/8caSBeSIZkZgsDWy
Date: Wed, 21 May 2014 12:45:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCHv5 09/10] DTS: ARM: OMAP3-N900: Add SSI support
Message-ID: <20140521194527.GM17417@atomide.com>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
 <20140521182513.GA26285@earth.universe>
 <20140521184319.GL17417@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521184319.GL17417@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140521 11:44]:
> * Sebastian Reichel <sre@kernel.org> [140521 11:26]:
> > The hwmod data may be wrong. The information from commit
> > 398917ce161e10d3c66afaefdb89c73c64c4b02d was simply
> > interpolated from all information I found. The OMAP3
> > public TRM does not contain *any* information about the
> > ssi IP-Core.

Yeah seems to be just reserved..
 
> It's probably something with the sysc or idlemodes that
> keeps things from idling. Maybe wrong address? Or wrong
> flags? I'm pretty sure it was the first .dts patch out of
> these two as the second one alone did not apply.

Hmm yeah below is probably how it should be, does this
work for you? With this fix applied and your ssi dts
patches n900 keeps hitting off-idle for me.

Regards,

Tony

8< --------
From: Tony Lindgren <tony@atomide.com>
Date: Wed, 21 May 2014 12:31:35 -0700
Subject: [PATCH] ARM: OMAP2+: Fix ssi hwmod entry to allow idling

The current entry prevents system from idling if
the hwmod is defined in the .dts file so let's
change the idlemodes.

Note that I'm not sure we have SYSC_HAS_EMUFREE
and SYSS_HAS_RESET_STATUS, but that can be
verified later on.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3692,9 +3692,7 @@ static struct omap_hwmod_class_sysconfig omap34xx_ssi_sysc = {
 	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_EMUFREE |
 			   SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE |
 			   SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
-			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
 	.sysc_fields	= &omap_hwmod_sysc_type1,
 };
 
