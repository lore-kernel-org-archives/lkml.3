Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab3K1Pks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:40:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52619 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab3K1Pkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:40:43 -0500
Date: Thu, 28 Nov 2013 16:40:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128154035.GE10022@twins.programming.kicks-ass.net>
References: <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143857.GU10022@twins.programming.kicks-ass.net>
 <20131128153443.GB11956@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128153443.GB11956@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:34:43PM +0100, Oleg Nesterov wrote:
> But note that in the longer term we might want even more. We probably
> want a non-daemonized thread controlled by the user-space. And even
> more, this thread should be per-namespace (this needs a lot more
> discussion).

Which namespace? PID namespace I presume where we can have a 'new' init
task and everything.

I'm not sure, are any of these things (workqueues, userspace helpers)
pid namespace aware? If not it doesn't seem to make sense to expose this
to nested PID namespaces and would be something special for the root
namespace.

> But whataver we do later, I believe that the patch from Zhang should
> be applied now.

Probably, although with a much adjusted changelog.
