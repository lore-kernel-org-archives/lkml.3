Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaBGQKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:10:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaBGQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:10:15 -0500
Date: Fri, 7 Feb 2014 17:10:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Torsten Duwe <duwe@lst.de>, Scott Wood <scottwood@freescale.com>,
        Tom Musta <tommusta@gmail.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140207161004.GD9987@twins.programming.kicks-ass.net>
References: <20140206103736.GA18054@lst.de>
 <20140206163837.GT2936@laptop.programming.kicks-ass.net>
 <20140206173727.GA13048@lst.de>
 <1391717992.6733.232.camel@snotra.buserror.net>
 <20140207090248.GB26811@lst.de>
 <87C29DBB-41E7-4B6C-9089-3C7756FBAE07@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87C29DBB-41E7-4B6C-9089-3C7756FBAE07@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 09:51:16AM -0600, Kumar Gala wrote:
> 
> On Feb 7, 2014, at 3:02 AM, Torsten Duwe <duwe@lst.de> wrote:
> 
> > On Thu, Feb 06, 2014 at 02:19:52PM -0600, Scott Wood wrote:
> >> On Thu, 2014-02-06 at 18:37 +0100, Torsten Duwe wrote:
> >>> On Thu, Feb 06, 2014 at 05:38:37PM +0100, Peter Zijlstra wrote:
> >> 
> >>>> Can you pair lwarx with sthcx ? I couldn't immediately find the answer
> >>>> in the PowerISA doc. If so I think you can do better by being able to
> >>>> atomically load both tickets but only storing the head without affecting
> >>>> the tail.
> > 
> > Can I simply write the half word, without a reservation, or will the HW caches
> > mess up the other half? Will it ruin the cache coherency on some (sub)architectures?
> 
> The coherency should be fine, I just can’t remember if you’ll lose the reservation by doing this.

It should; I suppose; seeing how you 'destroy' the state it got from the
load.

> >> Plus, sthcx doesn't exist on all PPC chips.
> > 
> > Which ones are lacking it? Do all have at least a simple 16-bit store?
> 
> Everything implements a simple 16-bit store, just not everything implements the store conditional of 16-bit data.

Ok, so then the last version I posted should work on those machines.
