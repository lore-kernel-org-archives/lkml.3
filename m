Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaE0Uf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:35:56 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13920 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbaE0Ufx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:35:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+s/570Wq0dpVZSXYs4Z37F
Date: Tue, 27 May 2014 13:35:44 -0700
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
Message-ID: <20140527203543.GB32336@atomide.com>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
 <20140521182513.GA26285@earth.universe>
 <20140521184319.GL17417@atomide.com>
 <20140521194527.GM17417@atomide.com>
 <20140521215055.GA26362@earth.universe>
 <20140521220807.GB14520@atomide.com>
 <20140522000558.GC29118@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522000558.GC29118@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [140521 17:06]:
> On Wed, May 21, 2014 at 03:08:07PM -0700, Tony Lindgren wrote:
> > * Sebastian Reichel <sre@kernel.org> [140521 14:51]:
> > > 
> > > Feel free to add Tested-by/Acked-By to the hwmod patch.
> > 
> > OK thanks for testing.
> 
> You are welcome.
> 
> > I'll apply your dts changes as soon as I have an ack from Paul on
> > the hwmod changes. Probably best to queue them together to avoid
> > PM breaking.
> 
> Ok. Sounds legit.

Based on chatting with Paul it seems that we most likely don't have
bits for sysc_flags for SYSC_HAS_EMUFREE or SYSS_HAS_RESET_STATUS
either. So applying the updated patch below, and the SSI dts changes
into omap-for-v3.16/dt-v2.

I'm keeping your previous ack Sebastian as the the idlemodes did
not change from the previous version, hopefully that's OK with you.

Regards,

Tony

8< ------------------
From: Tony Lindgren <tony@atomide.com>
Date: Wed, 21 May 2014 12:31:35 -0700
Subject: [PATCH] ARM: OMAP2+: Fix ssi hwmod entry to allow idling

The current entry prevents system from idling if
the hwmod is defined in the .dts file so let's
change the idlemodes.

Note that we probably don't have SYSC_HAS_EMUFREE
or SYSS_HAS_RESET_STATUS either. If we do, those
can be added later on.

Acked-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3689,12 +3689,9 @@ static struct omap_hwmod_class_sysconfig omap34xx_ssi_sysc = {
 	.rev_offs	= 0x0000,
 	.sysc_offs	= 0x0010,
 	.syss_offs	= 0x0014,
-	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_EMUFREE |
-			   SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE |
-			   SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
-	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
-			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
-			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_MIDLEMODE |
+			   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
 	.sysc_fields	= &omap_hwmod_sysc_type1,
 };
 
