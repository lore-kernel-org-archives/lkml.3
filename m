Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab3K1Odg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:33:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab3K1Odc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:33:32 -0500
Date: Thu, 28 Nov 2013 15:34:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131128143411.GA10872@redhat.com>
References: <20131125121416.GB23829@redhat.com> <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn> <20131126180420.GA18172@redhat.com> <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn> <20131127183117.GB13098@mtj.dyndns.org> <20131128091358.GH10022@twins.programming.kicks-ass.net> <20131128114542.GA3826@redhat.com> <20131128121748.GN10022@twins.programming.kicks-ass.net> <20131128133152.GA821@redhat.com> <20131128134124.GS10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128134124.GS10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Peter Zijlstra wrote:
>
> On Thu, Nov 28, 2013 at 02:31:52PM +0100, Oleg Nesterov wrote:
> > I _guess_ usermodehelper_init() should use WQ_SYSFS then, and in this case
> > the user can write to wq_cpumask_store somewhere in /sys/.
>
> WTF is that and why are we creating alternative affinity interfaces when
> sched_setaffinity() is a prefectly fine one?

Because there is no a simple workqueue/thread connection, I guess.

And I do not understand why do you dislike this.

For example. Please note that with the new design we can even kill
khelper_wq and the ugly kmod_thread_locker hack (just in case, I am not
saying that the patch which added kmod_thread_locker was ugly ;).

We can just use one of the system_ WQ_UNBOUND workqueues which has
the "large enough" max_active.

Oleg.

