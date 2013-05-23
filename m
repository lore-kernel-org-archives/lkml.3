Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3EWMDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:03:02 -0400
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:36810 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758489Ab3EWMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:03:00 -0400
Date: Thu, 23 May 2013 13:58:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: boris brezillon <b.brezillon@overkiz.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
Message-ID: <20130523115845.GA24476@game.jcrosoft.org>
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com>
 <1369299909-10078-2-git-send-email-b.brezillon@overkiz.com>
 <20130523090611.GG9937@game.jcrosoft.org>
 <519DE6A8.6040502@overkiz.com>
 <20130523120920.1df8e23a@skate>
 <20130523100951.GH9937@game.jcrosoft.org>
 <20130523122000.22a9a4d0@skate>
 <20130523102601.GI9937@game.jcrosoft.org>
 <20130523132255.3acf4431@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523132255.3acf4431@skate>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 392939068402019178
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:22 Thu 23 May     , Thomas Petazzoni wrote:
> Dear Jean-Christophe PLAGNIOL-VILLARD,
> 
> On Thu, 23 May 2013 12:26:01 +0200, Jean-Christophe PLAGNIOL-VILLARD
> wrote:
> 
> > > Did you read what I write? In arch/arm/mach-at91/pm.c, the only
> > > accesses made to the AIC registers are for pr_debug() calls, i.e only
> > > to print some debugging messages. I believe those ones can simply be
> > > removed to decouple the pm.c code from the irq.c code.
> > 
> > yes I read and yes I do not want to move code before we do cleanup MANDATORY
> 
> Then please explain to our volunteer contributor what sort of cleanup
> is required. Simply NACKing without offering any insight as to how
> things should be done is completely useless, counter-productive, and a
> complete abuse of a maintainer's power over contributors.
> 
> > >  * PATCH 1: remove usage of AIC registers for debug messages in pm.c
> > NACK I do want this debug, very usefull to debug pm
> 
> For the cases where you need to debug this stuff, you can always re-add
> some instrumentation in this code to dump whatever you want.
> 
> Or, alternatively, we can make the irqchip driver show using
> pr_debug() the value of IMR in its ->suspend() hook, the value of IMR &
> IPR in its ->resume() hook, and the pm.c code can show the PMC_PCSR on
> suspend. This way, you have all the informations you need for debugging.

if you read the code as you said both of them are link PMC & AIC so you can
not hope to split it as both of the IP contain part of the information

so no I want the information right where it's
> 
> Having the PM driver and the irqchip driver step on each other register
> areas is anyway a bad idea, especially when the only reason to do so is
> for two debugging messages that can be implemented differently.

> 
> Notice that this solution can always be improved later on if needed,
> with further cleanups from you.
> 
> But please stop rejecting valid patches from contributors, just because
> the code is not coming from you. What Boris is proposing is perfectly
so If I read you non clean code can come mainline, wow this not the way to
work. If for you do half clean is enough to go mainline. You really need to
change your way of working.

Best Regards,
J.
