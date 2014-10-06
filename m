Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaJFNBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:01:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:54225 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaJFNBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:01:52 -0400
Date: Mon, 6 Oct 2014 15:01:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.11.1410060521010.27574@gentwo.org>
Message-ID: <alpine.DEB.2.11.1410061449290.4383@nanos>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <alpine.DEB.2.11.1410052331420.4383@nanos> <alpine.DEB.2.11.1410051824190.3424@gentwo.org> <alpine.DEB.2.11.1410060959510.4383@nanos> <alpine.DEB.2.11.1410060521010.27574@gentwo.org>
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
> For example the timer interrupt occurs 1000 times per second, so
> it is predictable that the timer interrupt will overflow in

Now the bad news is, that the timer interrupt if it is serviced via
the local timer interrupt is still using a 32bit counter because the
local timer interrupt does not go through the core interrupt code.

So if you want to fix that as well, you really need to think about the
32 bit case because there is no serialization for the interrupts which
are delivered directly from their own vector. And no, we should not
diverge 32 and 64 bit artificially here simply because the same 50
days wrap applies to both.

I really start to wonder whether all this is worth the trouble. It has
been this way forever and 1k timer interrupts per second is not really
a new thing either. So we did not change anything which suddenly makes
tools confused.

Thanks,

	tglx
