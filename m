Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3K1Pqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:46:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab3K1Pqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:46:31 -0500
Date: Thu, 28 Nov 2013 16:47:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131128154719.GA14011@redhat.com>
References: <20131128133152.GA821@redhat.com> <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128141329.GB3925@htj.dyndns.org> <20131128143145.GT10022@twins.programming.kicks-ass.net> <20131128143848.GD3925@htj.dyndns.org> <20131128145505.GX10022@twins.programming.kicks-ass.net> <20131128145723.GH3925@htj.dyndns.org> <20131128145948.GZ10022@twins.programming.kicks-ass.net> <20131128150722.GJ3925@htj.dyndns.org> <20131128151704.GC10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128151704.GC10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Peter Zijlstra wrote:
>
> So there's three useful parts to having a single parent task:
>
>  - its a task so you can change the entire task attribute set; current
>    and future.

You can't change, say, its fs->root.

OK, OK, this is almost off-topic, I am just trying to say that
(perhaps) in the longer term we might want even more than just
a dedicated kernel thread.

>  - new children will automatically get the desired attributes.

yes,

>  - all children are easily identified by virtual of being children of
>    said parent process.

Well, UMH_WAIT_PROC won't work in this case, or it will be "single-threaded"
too. OK, this is probably solvable, but nontrivial. In this case "khelper"
should act as a /sbin/init for user-mode helpers.

Oleg.

