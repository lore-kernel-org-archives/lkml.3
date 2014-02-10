Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaBJDHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:07:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:47653 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaBJDHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:07:06 -0500
Message-ID: <1392001526.3996.17.camel@pasglop>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Torsten Duwe <duwe@lst.de>, Scott Wood <scottwood@freescale.com>,
        Tom Musta <tommusta@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Date: Mon, 10 Feb 2014 14:05:26 +1100
In-Reply-To: <87C29DBB-41E7-4B6C-9089-3C7756FBAE07@kernel.crashing.org>
References: <20140206103736.GA18054@lst.de>
	 <20140206163837.GT2936@laptop.programming.kicks-ass.net>
	 <20140206173727.GA13048@lst.de>
	 <1391717992.6733.232.camel@snotra.buserror.net>
	 <20140207090248.GB26811@lst.de>
	 <87C29DBB-41E7-4B6C-9089-3C7756FBAE07@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 09:51 -0600, Kumar Gala wrote:
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

Yes you do.

> >> Plus, sthcx doesn't exist on all PPC chips.
> > 
> > Which ones are lacking it? Do all have at least a simple 16-bit store?
> 
> Everything implements a simple 16-bit store, just not everything implements the store conditional of 16-bit data.

Ben.

> - k--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


