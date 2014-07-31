Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaGaWyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:54:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:37905 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaGaWyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:54:16 -0400
Date: Fri, 1 Aug 2014 00:54:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup
 interrupts
In-Reply-To: <2140085.bSS0bVjyxJ@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1408010016360.4997@nanos>
References: <20140724212620.GO3935@laptop> <2084079.fEC1AulnFk@vostro.rjw.lan> <alpine.DEB.2.10.1407311230420.4997@nanos> <2140085.bSS0bVjyxJ@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Rafael J. Wysocki wrote:
> On Thursday, July 31, 2014 12:44:24 PM Thomas Gleixner wrote:
> > > > Aside of that I want to see a coherent explanation why a shared MSI
> > > > interrupt makes any sense at all.
> > > > 
> > > > 25:  1 <....> 0   PCI-MSI-edge      aerdrv, PCIe PME
> > > >
> > > > AFAICT, that's the primary reason why you insist to support wakeup
> > > > sources on shared irq lines. And to be honest, it's utter bullshit.
> > > 
> > > No, this isn't the primary reason.
> > > 
> > > Here's /proc/interrupts from my MSI Wind system and, as you can see,
> > > PCIe PME are (a) not MSI and (b) shared with some interesting things
> > > (USB, WiFi and the GPU).
> > 
> > >  16:       5217          0   IO-APIC-fasteoi   PCIe PME, uhci_hcd:usb4, i915
> > >  17:      13964          0   IO-APIC-fasteoi   PCIe PME, rtl818x_pci
> > 
> > So the obvious question is: WHY are they not using MSI?
> > 
> > Just because MSI fucked up the MSI configuration of the device or is
> > there any sane explanation for it?
> 
> It looks like they don't use MSI on that machine at all, so perhaps the chipset
> is not capable of that or similar.  I'm not sure why it matters, though.  The
> system shipped like that and with Linux on it, so we should be able to
> handle it regardless.

Sorry, but this is outright hillarious.

#1 "so perhaps the chipset is not capable of that or similar."

   This is a fricking Intel chipset. All Intel chipsets which have a
   PCIe root hub are MSI capable at least to my restricted knowledge.

   As an Intel employee you could have had the decency to RTFM of the
   chipset which is in the machine you care about.

#2 "I'm not sure why it matters"

   It matters a lot.
   
   You're just fostering the industry mentality of "it works for us,
   lets ship it" simply because you tell them:

     No matter what brainfarts you have or what level of complete
     ignorance and incompetence you have, we're going to cope with it.

   You are sending out the wrong message. The message needs to be:

     Despite your completely idiotic implementation which renders a
     perfectly well designed piece of modern hardware into a last
     century piece of shit, we went out on a limb to provide the
     victims of your incompetence, i.e. your paying customers, a state
     of the art user experience.

  See the difference ?

The only point where I agree is that we want to handle it, but not
without pointing out that this stuff is a major piece of shite, which
should not ever had been offered to customers who simply are not able
to judge the shit level before spending their hard earned bucks for
it.

I'm well aware that neither Intel nor any other silicon vendor gives a
rats ass about this as long as they sell enough chips. But that's no
excuse for wasting the brains of community developers for no value,
simply because that could have been avoided by applying a fraction of
the brain power, which is necessary to cope with the damage, in the
first place.

I don't care how you feel about that, but I very much care about the
waste of my own precious time.

Thanks,

	tglx
