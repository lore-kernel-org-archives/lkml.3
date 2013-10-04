Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3JDTaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:30:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:54061 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754283Ab3JDTaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:30:18 -0400
Date: Fri, 4 Oct 2013 15:30:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] rcusync: introduce struct rcu_sync_ops
Message-ID: <20131004153012.19245adb@gandalf.local.home>
In-Reply-To: <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com>
References: <20131004184614.GA17536@redhat.com>
	<20131004184629.GA17550@redhat.com>
	<CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Oct 2013 12:12:25 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:


>  - together with using a few inline functions, suddenly the "indirect"
> jumps through this type descriptor end up actually being nice direct
> compile-time constants: iow, they get turned into direct jumps.

As all the rcu_synchronization() methods (on non UP) are quite
expensive, I doubt that this optimization is worth anything.

> 
> Tadaa. You actually get good code generation, and you use *less*
> dynamic memory since you don't have to have this pointer to the
> descriptor.

Getting rid of the extra dynamic memory and the pointer business, on the
other hand, does make your suggestion worth doing.

-- Steve

