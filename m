Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936759Ab3DJRcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:32:25 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:61434 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935720Ab3DJRcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:32:24 -0400
Date: Wed, 10 Apr 2013 19:32:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130410173219.GG21951@gmail.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
 <20130326140147.GB2029@redhat.com>
 <CAFTL4hyJxwh056=bTsSFcpZ7QLRsvsGbni=ueUHE6c1n8dmQ7Q@mail.gmail.com>
 <20130410125111.GA12923@gmail.com>
 <CAFTL4hxsTMZhNqC9jkrc5L3zEr-KFhxvwHqk+q=0zRn6wraWSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxsTMZhNqC9jkrc5L3zEr-KFhxvwHqk+q=0zRn6wraWSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/4/10 Ingo Molnar <mingo@kernel.org>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> Of course 128 bits ops are very expensive, so to help you evaluating the
> >> situation, this is going to happen on every call to task_cputime_adjusted() and
> >> thread_group_adjusted(), namely:
> >
> > It's really only expensive for divisions. Addition and multiplication should be
> > straightforward and relatively low overhead, especially on 64-bit platforms.
> 
> Ok, well we still have one division in the scaling path. I'm mostly
> worried about the thread group exit that makes use of it through
> threadgroup_cputime_adjusted(). Not sure if we can avoid that.

I see, scale_stime()'s use of div64_u64_rem(), right?

I swapped out the details already, is there a link or commit ID that explains 
where we hit 64-bit multiplication overflow? It's due to accounting in nanosecs, 
spread out across thousands of tasks potentially, right?

But even with nsecs, a 64-bit variable ought to be able to hold hundreds of years 
worth of runtime. How do we overflow?

Thanks,

	Ingo
