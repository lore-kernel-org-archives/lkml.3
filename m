Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaJFP2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:28:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:54914 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaJFP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:28:50 -0400
Date: Mon, 6 Oct 2014 17:28:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.11.1410061014080.29937@gentwo.org>
Message-ID: <alpine.DEB.2.11.1410061726510.4383@nanos>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <alpine.DEB.2.11.1410052331420.4383@nanos> <alpine.DEB.2.11.1410051824190.3424@gentwo.org> <alpine.DEB.2.11.1410060959510.4383@nanos> <alpine.DEB.2.11.1410060521010.27574@gentwo.org> <alpine.DEB.2.11.1410061449290.4383@nanos>
 <alpine.DEB.2.11.1410061014080.29937@gentwo.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014, Christoph Lameter wrote:

> On Mon, 6 Oct 2014, Thomas Gleixner wrote:
> 
> > So if you want to fix that as well, you really need to think about the
> > 32 bit case because there is no serialization for the interrupts which
> > are delivered directly from their own vector. And no, we should not
> > diverge 32 and 64 bit artificially here simply because the same 50
> > days wrap applies to both.
> 
> Is it a divergence if both 64bit and 32 bit are unsing unsigned long?

Sigh, yes. Because unsigned long is 32bit on a 32bit architecture. So
the change would be NOP for 32bit and 32bit would still suffer from
the wrap arounds etc.
 
> >
> > I really start to wonder whether all this is worth the trouble. It has
> > been this way forever and 1k timer interrupts per second is not really
> > a new thing either. So we did not change anything which suddenly makes
> > tools confused.
> 
> Tools expect the number of interrupt to increase linearly and not jump by
> 2^32 once in awhile. There are functions in the kernel (/proc/stat) that
> sum up various interrupt counters and that are types unsigned long. These
> larger numbers can suddenly jump by 2^32. Its pretty unusual for a 64 bit
> conter to do that and it requires some head scratching until we figured
> that one out.

I understand that, I just wonder why nobody noticed before. It's been
that way forever :)

Thanks,

	tglx

