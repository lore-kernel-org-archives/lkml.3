Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaCUEzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 00:55:14 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55479 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCUEzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 00:55:11 -0400
Date: Fri, 21 Mar 2014 10:25:01 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
Message-ID: <20140321045501.GD30295@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140319154705.GB8557@laptop.programming.kicks-ass.net>
 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
 <20140320053350.GB30295@linux.vnet.ibm.com>
 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
 <1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
 <1395342510.14694.43.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFw8wSe-DUtZ8=rjFJzXYmOSsZ0JzS-_jsZKrDai8LZMXw@mail.gmail.com>
 <1395346808.14694.62.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1395346808.14694.62.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032104-1396-0000-0000-0000048027AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Ok, so a big reason why this patch doesn't apply cleanly after reverting
> is because *most* of the changes were done at the top of the file with
> regards to documenting the ordering guarantees, the actual code changes
> are quite minimal.
> 
> I reverted commits 99b60ce6 (documentation) and b0c29f79 (the offending
> commit), and then I cleanly applied the equivalent ones from v3 of the
> series (which was already *tested* and ready for upstream until you
> suggested looking into the alternative spinlock approach):
> 
> https://lkml.org/lkml/2013/12/19/624
> https://lkml.org/lkml/2013/12/19/630

I reverted commits 99b60ce6 and b0c29f79. Then applied the patches in
the above url. The last one had a reject but it was pretty
straightforward to resolve it. After this, specjbb completes. 

So reverting and applying v3 3/4 and 4/4 patches works for me.

-- 
Thanks and Regards
Srikar Dronamraju

