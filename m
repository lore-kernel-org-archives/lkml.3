Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030656AbaDJUzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:55:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57500 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934898AbaDJUzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:55:16 -0400
Date: Thu, 10 Apr 2014 22:55:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
 for_each_thread()
Message-ID: <20140410205511.GP10526@twins.programming.kicks-ass.net>
References: <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
 <20140409171607.GA13498@dyad.arnhem.chello.nl>
 <20140409173233.GA28615@redhat.com>
 <20140409183017.GF10526@twins.programming.kicks-ass.net>
 <20140409194603.GB5854@redhat.com>
 <20140409194957.GD26782@laptop.programming.kicks-ass.net>
 <20140410161955.GG13658@twins.programming.kicks-ass.net>
 <20140410172938.GA32332@redhat.com>
 <20140410173610.GG26782@laptop.programming.kicks-ass.net>
 <20140410191525.GB13925@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410191525.GB13925@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 09:15:25PM +0200, Oleg Nesterov wrote:
> So far I can see only 2 users, __exit_signal() and complete_signal().

If that's it we could just open-code them and be done.

> May be next_tid(), but in fact it needs next_thread_or_zero(). And this
> connects to check_hung_task(). What they actually (OK, perhaps) need is
> for_each_thread_continue, like list_for_each_entry_continue_rcu.

That could work I suppose; brain has left the building already..

> We will see. I didn't finish this all because I was distracted (and lazy
> of course ;).

:-)
