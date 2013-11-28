Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab3K1OoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:44:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51357 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3K1OoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:44:09 -0500
Date: Thu, 28 Nov 2013 15:43:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128144359.GL3694@twins.programming.kicks-ass.net>
References: <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128143145.GT10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 03:31:45PM +0100, Peter Zijlstra wrote:
> Sure, we absolutely must set it for per-cpu workqueues (and their
> workers) otherwise we cannot guarantee correctness. Same for per-node if
> we have that.

On that, the per-node thing is debatable. There's no correctness issues
with per-node stuff as we have with per-cpu storage.

And if there's no correctness implications we should not force things.
