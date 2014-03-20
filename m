Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbaCTUUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:20:16 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:26325 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaCTUUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:20:14 -0400
Message-ID: <1395346808.14694.62.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 13:20:08 -0700
In-Reply-To: <CA+55aFw8wSe-DUtZ8=rjFJzXYmOSsZ0JzS-_jsZKrDai8LZMXw@mail.gmail.com>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
	 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
	 <20140320053350.GB30295@linux.vnet.ibm.com>
	 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
	 <1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
	 <1395342510.14694.43.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFw8wSe-DUtZ8=rjFJzXYmOSsZ0JzS-_jsZKrDai8LZMXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 12:25 -0700, Linus Torvalds wrote:
> On Thu, Mar 20, 2014 at 12:08 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > Oh, it does. This atomics technique was tested at a customer's site and
> > ready for upstream.
> 
> I'm not worried about the *original* patch. I'm worried about the
> incremental one.
> 
> Your original patch never applied to my tree - I think it was based on
> -mm or something. So I couldn't verify my "let's go back to the
> explicit 'waiters'" incremental patch against reverting and
> re-applying the original patch.

Ok, so a big reason why this patch doesn't apply cleanly after reverting
is because *most* of the changes were done at the top of the file with
regards to documenting the ordering guarantees, the actual code changes
are quite minimal.

I reverted commits 99b60ce6 (documentation) and b0c29f79 (the offending
commit), and then I cleanly applied the equivalent ones from v3 of the
series (which was already *tested* and ready for upstream until you
suggested looking into the alternative spinlock approach):

https://lkml.org/lkml/2013/12/19/624
https://lkml.org/lkml/2013/12/19/630

Assuming the atomics solves the issue, would you be willing to take this
path? Any pending documentation fixes can be added afterwards. The
important thing is that the actual code is well tested.

Thanks,
Davidlohr

