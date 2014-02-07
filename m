Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaBGRYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:24:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:47429 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGRYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:24:37 -0500
Date: Fri, 7 Feb 2014 18:24:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carlo Caione <carlo.caione@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans De Goede <hdegoede@redhat.com>, emilio@elopez.com.ar,
        linux-sunxi@googlegroups.com, t.figa@samsung.com
Subject: Re: [linux-sunxi] Re: [PATCH] irq: Add new flag to ack level-triggered
 interrupts before unmasking
In-Reply-To: <CAOQ7t2b5qVTUXOB4iWAOoTehm=u6zxP0-zQmirSF0DvEk8KddQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402071721350.21991@ionos.tec.linutronix.de>
References: <1391721117-27446-1-git-send-email-carlo@caione.org> <alpine.DEB.2.02.1402062213590.21991@ionos.tec.linutronix.de> <CAOQ7t2Z0agZdDZ_OQZPtXWXoi5NMTcOOZz04q6wEVNy0rxn4AA@mail.gmail.com> <alpine.DEB.2.02.1402062229000.21991@ionos.tec.linutronix.de>
 <CAOQ7t2bzz9vKh_5h2nF=m+JpeYVa=Ttd4XQgrAa6Lhdzjg_Qxw@mail.gmail.com> <alpine.DEB.2.02.1402071121310.21991@ionos.tec.linutronix.de> <CAOQ7t2b5qVTUXOB4iWAOoTehm=u6zxP0-zQmirSF0DvEk8KddQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Carlo Caione wrote:
> Yeah, no really difference between threaded and non threaded.
> For the record, from a mail exchange with Allwinner's engineers: "the
> NMI module is a signal conversion module. It catches the NMI pin's
> state and generates irq to GIC", so GIC does not really ACK anything.
> BTW being a dummy "signal conversion module" this is probably why I
> still need to clear the pending status even though my IRQ line has
> already been cleared.

A pretty useless signal conversion module it seems creating a big mess
for a single interrupt line :)

> > I'm not against having a flag, but this should be done less convoluted
> > and have proper names which make the use case clear along with a good
> > technical explanation of the flag in the comment.
> 
> Ok, at this point do you think that a patch in the core could be
> useful or is it better to stick with modifying the unmask callback?

Not sure, really, but I tend to a core patch. Though we really want to
know whether the issue is threaded only or not. If it's a general
issue then this wants to go into unmask_irq() itself and not into an
extra unmask_threaded_irq() function.

Thanks,

	tglx
