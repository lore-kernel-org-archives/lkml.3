Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3EWKOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:14:07 -0400
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:34350 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751792Ab3EWKOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:14:05 -0400
Date: Thu, 23 May 2013 12:09:51 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: boris brezillon <b.brezillon@overkiz.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
Message-ID: <20130523100951.GH9937@game.jcrosoft.org>
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com>
 <1369299909-10078-2-git-send-email-b.brezillon@overkiz.com>
 <20130523090611.GG9937@game.jcrosoft.org>
 <519DE6A8.6040502@overkiz.com>
 <20130523120920.1df8e23a@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523120920.1df8e23a@skate>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 17000525644689550186
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeihedrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:09 Thu 23 May     , Thomas Petazzoni wrote:
> Dear boris brezillon,
> 
> On Thu, 23 May 2013 11:51:36 +0200, boris brezillon wrote:
> > On 23/05/2013 11:06, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > On 11:05 Thu 23 May     , Boris BREZILLON wrote:
> > >> Move arch/arm/mach-at91/irq.c to drivers/irqchip/irq-at91.c.
> > >> Move arch/arm/mach-at91/at91_aic.h to
> > >> arch/arm/mach-at91/include/mach/at91_aic.h to avoid ugly reference
> > >> to header file :
> > >> #include "../../arch/arm/mach-at91/at91_aic.h"
> > > no we are going to drop arch/arm/mach-at91/include/mach for multi support
> > >
> > > arch/arm/mach-at91/include/mach is for removal
> > What should be done ?
> > 
> > include ../../arch/arm/mach-at91/at91_aic.h from irq-at91.c
> > 
> > or
> > 
> > move at91_aic.h into drivers/irqchips and patch every non dt board to
> > include ../../../drivers/irqchip/at91_aic.h
> 
> You can put it in <linux/irqchip/at91-aic.h>, there are already a few
> headers there. But I think it's not the right solution.
> 
> *However*, ideally, this header should disappear completely. All the
> register defines should go directly into the driver C file. The only
> usage of the AIC defines outside of the IRQ driver are for debug prints
> in the pm.c code, which I think you could get rid of.
> 
> Ditto for the at91_aic_{read,write} macros.
> 
> The NR_AIC5_IRQS can also move to the driver itself.
> 
> The only remaining one would be NR_AIC_IRQS, you can't get rid of it,
> because it's used for the IRQ priority arrays. But I believe keeping
> this one in <linux/irqchip/at91-aic.h> is reasonable.

do want either as we expose the register acces for pm & co

until this is cleanup NACK

Best Regards,
J.
