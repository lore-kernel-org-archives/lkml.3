Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaJFHyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 03:54:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:52969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaJFHyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 03:54:18 -0400
Date: Mon, 6 Oct 2014 09:54:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Christoph Lameter <cl@linux.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <1412553572.11091.29.camel@edumazet-glaptop2.roam.corp.google.com>
Message-ID: <alpine.DEB.2.11.1410060952030.4383@nanos>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>  <alpine.DEB.2.11.1410031231420.4383@nanos>  <alpine.DEB.2.11.1410030653040.8496@gentwo.org>  <20141003120345.GA6652@localhost.localdomain>  <alpine.DEB.2.11.1410030706220.8990@gentwo.org> 
 <alpine.DEB.2.11.1410052331420.4383@nanos> <1412553572.11091.29.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014, Eric Dumazet wrote:
> On Sun, 2014-10-05 at 23:49 +0200, Thomas Gleixner wrote:
> 
> > Whats so hard about 64bit counters on 32bit machines?
> 
> Not hard, but not trivial either.
> 
> > 
> > > expensive to handle in particular because these counters are used in
> > > performance critical hotpaths.
> > 
> > The expensive overhead is a single "adcl" instruction.
> > 
> 
> Assuming a reader do not care of reading garbage yes, while carry is not
> yet propagated.

Readers and writers are serialized via desc->lock.

Thanks,

	tglx
