Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaBGJCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:02:55 -0500
Received: from verein.lst.de ([213.95.11.211]:43031 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaBGJCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:02:52 -0500
Date: Fri, 7 Feb 2014 10:02:48 +0100
From: Torsten Duwe <duwe@lst.de>
To: Scott Wood <scottwood@freescale.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Tom Musta <tommusta@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140207090248.GB26811@lst.de>
References: <20140206103736.GA18054@lst.de> <20140206163837.GT2936@laptop.programming.kicks-ass.net> <20140206173727.GA13048@lst.de> <1391717992.6733.232.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391717992.6733.232.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 02:19:52PM -0600, Scott Wood wrote:
> On Thu, 2014-02-06 at 18:37 +0100, Torsten Duwe wrote:
> > On Thu, Feb 06, 2014 at 05:38:37PM +0100, Peter Zijlstra wrote:
> 
> > > Can you pair lwarx with sthcx ? I couldn't immediately find the answer
> > > in the PowerISA doc. If so I think you can do better by being able to
> > > atomically load both tickets but only storing the head without affecting
> > > the tail.

Can I simply write the half word, without a reservation, or will the HW caches
mess up the other half? Will it ruin the cache coherency on some (sub)architectures?

> Plus, sthcx doesn't exist on all PPC chips.

Which ones are lacking it? Do all have at least a simple 16-bit store?

	Torsten

