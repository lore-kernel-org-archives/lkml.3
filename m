Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbbATRDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:03:53 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23670 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbbATRDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:03:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19QfDZJw9+TOa43DqgS1QNh
Date: Tue, 20 Jan 2015 09:00:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: ARM: OMAP3: MACH_OMAP3517EVM?
Message-ID: <20150120170022.GE7718@atomide.com>
References: <1421744597.9655.92.camel@x220>
 <20150120164455.GD7718@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120164455.GD7718@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [150120 08:52]:
> * Paul Bolle <pebolle@tiscali.nl> [150120 01:06]:
> > Tony,
> > 
> > Your commit 4d62dbda8561 ("ARM: OMAP3: Remove legacy support for
> > am3517-evm") is included in today's linux-next (ie, next-20150120). I
> > noticed because a script I use to check linux-next spotted a problem
> > caused by it.
> 
> OK thanks for spotting that.
>  
> > See, your commit removes the Kconfig symbol MACH_OMAP3517EVM. But
> > there's still a reference to that symbol in sound/soc/omap/Kconfig. This
> > means that in linux-next a symbol, SND_OMAP_SOC_AM3517EVM, cannot be set
> > anymore.
> > 
> > I assume a patch that address this (either by removing
> > SND_OMAP_SOC_AM3517EVM or by updating its dependencies) is queued
> > somewhere. Is that correct?
> 
> Not yet, I missed that part sorry. I'll add back the Kconfig symbol.
> I'll rather do the removal in smaller steps, and first remove the
> 3517 related board-*.c file before messing with the legacy drivers.

Below is a fix for this.

Regards,

Tony

8< ----------------
From: Tony Lindgren <tony@atomide.com>
Date: Tue, 20 Jan 2015 08:49:08 -0800
Subject: [PATCH] ARM: OMAP3: Add back Kconfig option MACH_OMAP3517EVM for ASoC

We still have SND_OMAP_SOC_AM3517EVM depending on MACH_OMAP3517EVM,
so let's keep MACH_OMAP3517EVM Kconfig option around for a little
bit longer.

This removes the dependency between ARM SoC changes and the ASoC
changes, and allows the following three options for the driver:

1. Update the driver for device tree based booting

2. Initialize the driver with legacy platform data, then update
   the driver for device tree based booting

3. Just remove the driver if there are no audio users for
   3517-evm board

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -213,6 +213,11 @@ config MACH_OVERO
 	default y
 	select OMAP_PACKAGE_CBB
 
+config MACH_OMAP3517EVM
+	bool "OMAP3517/ AM3517 EVM board"
+	depends on ARCH_OMAP3
+	default y
+
 config MACH_OMAP3_PANDORA
 	bool "OMAP3 Pandora"
 	depends on ARCH_OMAP3
