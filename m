Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab3K1OzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:55:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51710 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3K1OzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:55:12 -0500
Date: Thu, 28 Nov 2013 15:55:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128145505.GX10022@twins.programming.kicks-ass.net>
References: <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128143848.GD3925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128143848.GD3925@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 09:38:48AM -0500, Tejun Heo wrote:
> Hah?  No, we do not want to allow userland to be able to set
> affinities on any workqueue workers, period.  That's just inviting
> people to do weirdest things and then reporting things like "crypt
> jobs on some of our 500 machines end up stuck on a single cpu once in
> a while" which will eventually be tracked down to some weird shell
> script setting affinity on workers doing something else.

Because that is exactly what some users desire? Some RT and HPC people
want all those crypt jobs to run on a few designated cpus and not wreck
their compute jobs.
