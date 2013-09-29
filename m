Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3I2Vez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 17:34:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:20676 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754843Ab3I2Vew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 17:34:52 -0400
Date: Sun, 29 Sep 2013 17:34:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] introduce synchronize_sched_{enter,exit}()
Message-ID: <20130929173447.14accc5f@gandalf.local.home>
In-Reply-To: <20130929183634.GA15563@redhat.com>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
	<1378805550-29949-38-git-send-email-mgorman@suse.de>
	<20130917143003.GA29354@twins.programming.kicks-ass.net>
	<20130929183634.GA15563@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Sep 2013 20:36:34 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

 
> Why? Say, percpu_rw_semaphore, or upcoming changes in get_online_cpus(),
> (Peter, I think they should be unified anyway, but lets ignore this for
> now). Or freeze_super() (which currently looks buggy), perhaps something
> else. This pattern
> 

Just so I'm clear to what you are trying to implement... This is to
handle the case (as Paul said) to see changes to state by RCU and back
again? That is, it isn't enough to see that the state changed to
something (like SLOW MODE), but we also need a way to see it change
back?

With get_online_cpus(), we need to see the state where it changed to
"performing hotplug" where holders need to go into the slow path, and
then also see the state change to "no longe performing hotplug" and the
holders now go back to fast path. Is this the rational for this email?

Thanks,

-- Steve
