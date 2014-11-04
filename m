Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaKDMwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:52:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58838 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750866AbaKDMwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:52:45 -0500
Date: Tue, 4 Nov 2014 07:52:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 2/6] sched/rt: Optimize select_task_rq_rt() for
 non-RT curr task
Message-ID: <20141104075237.4eb9b5e6@gandalf.local.home>
In-Reply-To: <1415099585-31174-2-git-send-email-pang.xunlei@linaro.org>
References: <1415099585-31174-1-git-send-email-pang.xunlei@linaro.org>
	<1415099585-31174-2-git-send-email-pang.xunlei@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Nov 2014 19:13:01 +0800
"pang.xunlei" <pang.xunlei@linaro.org> wrote:

> When selecting the cpu for a waking RT task, if curr is a non-RT
> task which is bound only on this cpu, then we can give it a chance
> to select a different cpu(definitely an idle cpu if existing) for
> the RT task to avoid curr starving.

Absolutely not! An RT task doesn't give a crap if a non RT task is
bound to a CPU or not. We are not going to migrate an RT task to be
nice to a bounded non-RT task.

Migration is not cheap. It causes cache misses and TLB flushes. This is
not something that should be taken lightly.

Nack

-- Steve

