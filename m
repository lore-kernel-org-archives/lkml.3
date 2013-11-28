Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab3K1Tcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:32:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab3K1Tcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:32:45 -0500
Date: Thu, 28 Nov 2013 20:33:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 0/1] usermodehelper: kill
	____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131128193330.GA24767@redhat.com>
References: <20131127183117.GB13098@mtj.dyndns.org> <20131128091358.GH10022@twins.programming.kicks-ass.net> <20131128114542.GA3826@redhat.com> <20131128121748.GN10022@twins.programming.kicks-ass.net> <20131128133152.GA821@redhat.com> <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128142359.GA6420@redhat.com> <20131128143155.GC3925@htj.dyndns.org> <20131128150055.GA11956@redhat.com> <20131128150233.GA10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128150233.GA10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Peter Zijlstra wrote:
>
> On Thu, Nov 28, 2013 at 04:00:55PM +0100, Oleg Nesterov wrote:
> > And btw. Note ____call_usermodehelper()->set_cpus_allowed_ptr(cpu_all_mask).
> >
> > Even if we change the affinity of the "khelper" worker threads this
> > won't restrict the user-space helpers.
> >
> > I think this set_cpus_allowed_ptr() should die in any case?
>
> Yes. A while back someone proposed adding a magic cpumask to tweak in
> order to contain the usermode helpers.
>
> Obviously I thought that was a bad idea.

OK. let me send the trivial patch then, please take it or ack
for Andrew.

Assumung that you and Tejun agree with this change, of course.

Oleg.

