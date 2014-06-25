Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaFYGZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:25:18 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:60675 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaFYGZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:25:16 -0400
Date: Wed, 25 Jun 2014 08:25:11 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch,locking: Ciao arch_mutex_cpu_relax()
Message-ID: <20140625062510.GB4260@osiris>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
 <20140623065835.GF19860@laptop.programming.kicks-ass.net>
 <1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062506-2966-0000-0000-0000004DDE02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 08:06:55AM -0700, Davidlohr Bueso wrote:
> On Mon, 2014-06-23 at 08:58 +0200, Peter Zijlstra wrote:
> > While I like the general idea; does anyone have a better name for this?
> > So in particular, the difference is that on s390:
> > 
> >  cpu_relax()                - yields the vcpu
> >  arch_{,mutex_}cpu_relax()  - will actually spin-wait
> 
> iirc Heiko had suggested cpu_relax_simple() in the past. I don't think
> it's any better or worse than arch_cpu_relax(). For s390
> cpu_relax_noyield() would perhaps be suitable, but not very descriptive
> for the rest of the archs. I'm really lacking creativity for this name.

Maybe cpu_relax_spin() ? However that doesn't sound much better as well.

