Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaCSReZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaCSReX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:34:23 -0400
Date: Wed, 19 Mar 2014 18:33:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peng Tao <bergwolf@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Message-ID: <20140319173330.GA11923@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com> <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net> <CA+a=Yy567xtU0Osz+9-hTCNrzB65vE=ErYWTq880N+uEwG2DHA@mail.gmail.com> <20140318162319.GB5669@redhat.com> <CA+a=Yy51Ex=UdsCRn8Ty_s4XR4xbOZ_YAf3tejb=JyTgQ_QzRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy51Ex=UdsCRn8Ty_s4XR4xbOZ_YAf3tejb=JyTgQ_QzRA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Peng Tao wrote:
>
> On Wed, Mar 19, 2014 at 12:23 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Firtsly, cfs_block_sigs/cfs_block_sigsinv/etc are not exactly right,
> > they need set_current_blocked(). And you can read "old" lockless.
> >
> It seems that set_current_blocked() is not exported. Can we ask to export it?

Why not. If you are going to change this code to use set_current_blocked(),
I'd suggest you to send the "export set_current_blocked" patch in series.
Otherwise, if it is sent separately, your change will depend on another
tree.

Or you can use sigprocmask(). Actually it should die, but this won't happen
soon and it is already exported.

> And looking at other similar places like coda_block_signals(),

Yes, it can have much more users.

But note that set_current_blocked() can't help you to really block
SIGKILL anyway.

Could you explain why __l_wait_event() can't use TASK_UNINTERRUPTIBLE
instead of cfs_block_sigsinv(0) ?

Oleg.

