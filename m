Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaCTKIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:08:55 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37446 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaCTKIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:08:54 -0400
Date: Thu, 20 Mar 2014 15:38:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, paulus@samba.org,
        tglx@linutronix.de, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, mingo@kernel.org
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
Message-ID: <20140320100848.GC10406@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
 <20140320053350.GB30295@linux.vnet.ibm.com>
 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032010-9574-0000-0000-00000C88AB55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This problem suggests that we missed a wakeup for a task that was adding
> itself to the queue in a wait path. And the only place that can happen
> is with the hb spinlock check for any pending waiters. Just in case we
> missed some assumption about checking the hash bucket spinlock as a way
> of detecting any waiters (powerpc?), could you revert this commit and
> try the original atomic operations variant:
> 
> https://lkml.org/lkml/2013/12/19/630

I think the above url and the commit id that I reverted i.e
git://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b0c29f79ecea0b6fbcefc999
are the same.

Or am I missing something? 

-- 
Thanks and Regards
Srikar Dronamraju

