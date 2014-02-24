Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaBXAik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:38:40 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:37659 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbaBXAii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:38:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8DAOiTClOl5H4JgWdsb2JhbABZsCKRUYMHgSMOAQEWJiiCJQEBBAE6PwULCxgJFRAPAUcGiBAIxiUXjmQHhDgErhwo
From: Alistair Popple <alistair@popple.id.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/7] IBM Akebono: Add a SDHCI platform driver
Date: Mon, 24 Feb 2014 11:38:30 +1100
Message-ID: <278655068.asy5NBOYab@mexican>
User-Agent: KMail/4.9.5 (Linux/3.5.0-45-generic; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1773685.WfxOP0FuHM@wuerfel>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au> <1392964293-13687-2-git-send-email-alistair@popple.id.au> <1773685.WfxOP0FuHM@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 15:14:30 Arnd Bergmann wrote:
> On Friday 21 February 2014 17:31:27 Alistair Popple wrote:
> > +config MMC_SDHCI_OF_476GTR
> > +	tristate "SDHCI OF support for the IBM PPC476GTR SoC"
> > +	depends on MMC_SDHCI_PLTFM
> > +	depends on PPC_OF
> > +	help
> > +	  This selects the Secure Digital Host Controller Interface (SDHCI)
> > +	  found on the PPC476GTR SoC.
> > +
> > +	  If you have a controller with this interface, say Y or M here.
> > +
> > +	  If unsure, say N.
> 
> Your driver doesn't actually do anything beyond what is in the common
> sdhci-pltfm.c infrastructure. IMHO you really shoulnd't need a SoC
> specific abstraction for it at all and instead add a generic
> platform driver registration into sdhci-pltfm.c. I'd suggest
> you use "generic-sdhci" (similar to what we do for usb-ohci and usb-ehci
> now) as the compatible string and change your device tree to claim
> compatibility with that and your soc-specific string.

That's a reasonable point. I guess I was just following the example set by the 
other sdhci-* drivers. However on review they're not as generic as this one so 
I will merge this into sdhci-pltfm.c as suggested.

- Alistair

> 	Arnd
