Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554Ab3K1Lo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:44:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab3K1Lo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:44:56 -0500
Date: Thu, 28 Nov 2013 12:45:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131128114542.GA3826@redhat.com>
References: <20131114115551.GA30824@redhat.com> <20131114115618.GB30824@redhat.com> <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com> <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn> <20131125121416.GB23829@redhat.com> <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn> <20131126180420.GA18172@redhat.com> <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn> <20131127183117.GB13098@mtj.dyndns.org> <20131128091358.GH10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128091358.GH10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Peter Zijlstra wrote:
>
> On Wed, Nov 27, 2013 at 01:31:17PM -0500, Tejun Heo wrote:
> > On Wed, Nov 27, 2013 at 10:07:03AM +0800, zhang.yi20@zte.com.cn wrote:
> > > Userspace process doesn't want the PF_NO_SETAFFINITY, but its parent may be
> > > a kernel worker thread which has PF_NO_SETAFFINITY set, and this worker thread
> > > can do kernel_thread() to create the child.
> > > Clearing this flag in usersapce child to enable its migrating capability.
> > >
> > >
> > > Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> >
> > Acked-by: Tejun Heo <tj@kernel.org>
> >
> > cc'ing Ingo and Peter.  Ingo, I think this one doesn't really suit the
> > workqueue tree.  Can you please pick this one up w/ Oleg's ack added
> > and stable cc'd?  The original patch is
> >
> >   http://article.gmane.org/gmane.linux.kernel/1602429/raw
>
> So I don't get the problem; aren't all usermode helper thingies spawned
> by the khelper task, which doesn't have PG_NO_SETAFFINITY set?

It has? khelper is a workqueue thread, this flag is set by create_worker().

And it does kernel_thread() (not kthread_create()) so the child gets this
flag too.

> The Changelog is not explaining anything much -- so no I will not take
> this patch.

Well, perhaps the changelog can be more verbose and clear...

Zhang, I'm afraid you have to send v3 ;)

Oleg.

