Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaJEVtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:49:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:52108 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJEVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:49:18 -0400
Date: Sun, 5 Oct 2014 23:49:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
Message-ID: <alpine.DEB.2.11.1410052331420.4383@nanos>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014, Christoph Lameter wrote:
> On Fri, 3 Oct 2014, Richard Cochran wrote:
> 
> > >  DECLARE_PER_CPU(char *, irq_stack_ptr);
> > > -DECLARE_PER_CPU(unsigned int, irq_count);
> > > +DECLARE_PER_CPU(unsigned long, irq_count);
> >
> > Still 32 bit on 32 bit machines...
> 
> 64 bit counters on 32 bit machines are not an easy thing and could be

Whats so hard about 64bit counters on 32bit machines?

> expensive to handle in particular because these counters are used in
> performance critical hotpaths.

The expensive overhead is a single "adcl" instruction.

> I thought I better leave it alone on 32 bit.

And how exactly are we supposed to explain the different behaviour to
users?

Thanks,

	tglx
