Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab3K1Pph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:45:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800Ab3K1Ppg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:45:36 -0500
Date: Thu, 28 Nov 2013 16:00:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131128150055.GA11956@redhat.com>
References: <20131126180420.GA18172@redhat.com> <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn> <20131127183117.GB13098@mtj.dyndns.org> <20131128091358.GH10022@twins.programming.kicks-ass.net> <20131128114542.GA3826@redhat.com> <20131128121748.GN10022@twins.programming.kicks-ass.net> <20131128133152.GA821@redhat.com> <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128142359.GA6420@redhat.com> <20131128143155.GC3925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128143155.GC3925@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Tejun Heo wrote:
>
> * Is WQ_RESCUER actually necessary?  If not, WQ_RESCUER will be
>   dropped and the task bearing the name of the workqueue will no
>   longer exist.

WQ_MEM_RECLAIM, I guess. Probably not...

> * Is ordered execution necessary?  If not, it can be converted to
>   alloc_workqueue() or just to use system_wq.

I think no. This is the reason for kmod_thread_locker hack.

> khelper is special as its attributes get inherited to its children,
> so, yeah, we probably wanna keep that one's cpumask set to all.

And btw. Note ____call_usermodehelper()->set_cpus_allowed_ptr(cpu_all_mask).

Even if we change the affinity of the "khelper" worker threads this
won't restrict the user-space helpers.

I think this set_cpus_allowed_ptr() should die in any case?

Oleg.

