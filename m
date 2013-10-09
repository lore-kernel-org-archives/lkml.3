Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3JIHFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:05:20 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:39240 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3JIHFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:05:17 -0400
Date: Wed, 9 Oct 2013 07:05:16 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, balbi@ti.com, rnayak@ti.com, t-kristo@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP4: clock: Initialize USB DPLL
In-Reply-To: <514B1553.6030701@ti.com>
Message-ID: <alpine.DEB.2.02.1310090704180.30199@utopia.booyaka.com>
References: <1363873705-3224-1-git-send-email-rogerq@ti.com> <514B1553.6030701@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Thu, 21 Mar 2013, Roger Quadros wrote:

> +Paul
> 
> On 03/21/2013 03:48 PM, Roger Quadros wrote:
> > If the bootloader doesn't configure USB DPLL (e.g. in u-boot,
> > disable CONFIG_USB_EHCI_OMAP), then we get all sorts of problems
> > like
> > - division by zero errors at boot [1]
> > - USB DPLL fails to enter locked state
> > - USB EHCI Host is non functional
> > - Device can't enter OFF mode
> > 
> > Initializing the USB DPLL fixes all these issues.

Looks like I may have lost track of this - do we still need this one?

Also:

> > diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
> > index bfc46c1..6127bb9 100644
> > --- a/arch/arm/mach-omap2/cclock44xx_data.c
> > +++ b/arch/arm/mach-omap2/cclock44xx_data.c
> > @@ -53,6 +53,12 @@
> >   */
> >  #define OMAP4_DPLL_ABE_DEFFREQ				98304000
> >  
> > +/*
> > + * OMAP4450 TRM Rev X, section "3.6.3.9.5 DPLL_USB Preferred Settings"

4450?


- Paul
