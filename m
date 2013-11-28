Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab3K1MSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:18:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48681 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3K1MR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:17:58 -0500
Date: Thu, 28 Nov 2013 13:17:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128121748.GN10022@twins.programming.kicks-ass.net>
References: <20131114115618.GB30824@redhat.com>
 <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com>
 <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn>
 <20131125121416.GB23829@redhat.com>
 <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
 <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128114542.GA3826@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 12:45:42PM +0100, Oleg Nesterov wrote:
> It has? khelper is a workqueue thread, this flag is set by create_worker().
> 
> And it does kernel_thread() (not kthread_create()) so the child gets this
> flag too.

Urgh, but that's still completely wrong. khelper is a singlethread
workqueue, those should be unbound and therefore should not have this
flag set at all.

In fact, I know people want to set affinity on khelper to ensure all the
usermode helper tasks get spawned on the specific system-cpus and leave
the rest of the system unperturbed.

