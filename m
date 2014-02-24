Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaBXLck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:32:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:56589 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaBXLcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:32:39 -0500
Date: Mon, 24 Feb 2014 12:32:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [patch 03/26] powerpc: eeh: Kill another abuse of irq_desc
In-Reply-To: <20140224075607.GA20727@shangw.(null)>
Message-ID: <alpine.DEB.2.02.1402241232030.21251@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <20140223212736.562906212@linutronix.de> <20140224075607.GA20727@shangw.(null)>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Gavin Shan wrote:
> On Sun, Feb 23, 2014 at 09:40:09PM -0000, Thomas Gleixner wrote:
> >commit 91150af3a (powerpc/eeh: Fix unbalanced enable for IRQ) is
> >another brilliant example of trainwreck engineering.
> >
> >The patch "fixes" the issue of an unbalanced call to irq_enable()
> >which causes a prominent warning by checking the disabled state of the
> >interrupt line and call conditionally into the core code.
> >
> >This is wrong in two aspects:
> >
> >1) The warning is there to tell users, that they need to fix their
> >   asymetric enable/disable patterns by finding the root cause and
> >   solving it there.
> >
> >   It's definitely not meant to work around it by conditionally
> >   calling into the core code depending on the random state of the irq
> >   line.
> >
> >   Asymetric irq_disable/enable calls are a clear sign of wrong usage
> >   of the interfaces which have to be cured at the root and not by
> >   somehow hacking around it.
> >
> >2) The abuse of core internal data structure instead of using the
> >   proper interfaces for retrieving the information for the 'hack
> >   around'
> >
> >   irq_desc is core internal and it's clear enough stated.
> >
> >Replace at least the irq_desc abuse with the proper functions and add
> >a big fat comment why this is absurd and completely wrong.
> >
> 
> Thanks for pointing it out. I think we might have this patch for now
> and I'll look into individual drivers to fix the unbalanced function
> calls later one by one.

Fine with me. You wont escape my scan scripts :)

Thanks,

	tglx
