Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab3K1SMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:12:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab3K1SMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:12:19 -0500
Date: Thu, 28 Nov 2013 19:13:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131128181304.GA19628@redhat.com>
References: <20131128114542.GA3826@redhat.com> <20131128121748.GN10022@twins.programming.kicks-ass.net> <20131128133152.GA821@redhat.com> <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128141329.GB3925@htj.dyndns.org> <20131128143857.GU10022@twins.programming.kicks-ass.net> <20131128153443.GB11956@redhat.com> <20131128154035.GE10022@twins.programming.kicks-ass.net> <20131128162025.GA14937@redhat.com> <20131128163803.GG10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128163803.GG10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Peter Zijlstra wrote:
>
> So in specific, you say that piping a core file into a usermode helper
> is currently busted in pid-namespaces and that fixing that would indeed
> introduce such pid-namespace awareness to the usermode-helper stuff?

Perhaps yes. People want to run the core handler in the namespace of
the crashed task. And (perhaps) even dumping to the file should use
per-namespace ->root/etc.

(and of course core_pattern[] should not be global, but this is
 another story).

And there are other potential users. Say, nfsd user-mode helpers wants
to have the "right" mnt (at least) namespace.

But again, this all needs a lot of discussions. Even the API is not
actually clear. As for implementation, we could probably even force
->child_reaper (the subnamespace's init) to fork/exec the usermode
helper in this case. Or a namespace should explicitly create a thread
which should do this.

Oleg.

