Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaKWR5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:57:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaKWR5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:57:21 -0500
Date: Sun, 23 Nov 2014 18:56:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>
Subject: Re: task_stat splat
Message-ID: <20141123175641.GA11619@redhat.com>
References: <20141123111220.GA6436@pd.tnic> <20141123172256.GA9625@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141123172256.GA9625@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Oleg Nesterov wrote:
>
> On 11/23, Borislav Petkov wrote:
> >
> > where we end up with a zero PMD. RIP is corrupted too so we're somewhere
> > off in the fields.
>
> PMD = 0 is fine I guess, addr == 0 is not mapped.
>
> > Comment over thread_group_cputime() talks about dead tasks accounting
>
> This comment simply means that we also need to read the accumulated
> counters in tsk->signal.
>
> > which might be relevant as we're seeing not mapped page hierarchy so
> > something must have gone away recently but we try to look at it.
>
> This is called under ->siglock, we can't race with exit/etc. But this
> doesn't matter, it is not that we (say) get t == NULL or something like
> this.
>
> RIP == 0, and this looks "impossible", I do not see indirect function
> calls in this paths.

Ah, I didn't notice you mentioned tip/master... so it looks as if
sched_class->update_curr is NULL?

>
> > [42460.389625] Call Trace:
> > [42460.389635]  [<ffffffff810813d9>] ? task_sched_runtime+0x99/0xc0
> > [42460.389643]  [<ffffffff81088b5c>] thread_group_cputime+0x17c/0x2d0
>
> Could you identify somehow the line which matches task_sched_runtime+0x99 ?
> Probably do_task_delta_exec()...
>
> Oleg.

