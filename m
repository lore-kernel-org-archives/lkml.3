Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaKDOrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:47:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:29061 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753792AbaKDOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:47:10 -0500
Date: Tue, 4 Nov 2014 09:47:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 2/6] sched/rt: Optimize select_task_rq_rt() for
 non-RT curr task
Message-ID: <20141104094707.79e9ca86@gandalf.local.home>
In-Reply-To: <CADcy93XK9-p3iFw28qeA=q9Fp4_Qbd1Hoig6Tu5G+QfwxNWiow@mail.gmail.com>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
	<1415099585-31174-2-git-send-email-pang.xunlei@linaro.org>
	<20141104075237.4eb9b5e6@gandalf.local.home>
	<CADcy93XK9-p3iFw28qeA=q9Fp4_Qbd1Hoig6Tu5G+QfwxNWiow@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014 22:29:24 +0800
"pang.xunlei" <pang.xunlei@linaro.org> wrote:


> > Migration is not cheap. It causes cache misses and TLB flushes. This is
> > not something that should be taken lightly.
> Ok, thanks!
> But I think the PUSH operation optimized by the former patch is reasonable,
> since PUSH itselft does involve the Migration. Do I miss something?

For the first patch you may be right, but I want to think about it some
more. I want to make sure we are not adding any other type of overhead
with the extra calls.

-- Steve
