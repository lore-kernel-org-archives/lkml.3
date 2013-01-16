Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3APNEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:04:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44673 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3APNEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:04:45 -0500
X-AuditID: 9c930197-b7b76ae000000e7d-ff-50f6a56b363f
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] context_tracking: Add comments on interface and internals
References: <1358339577-28766-1-git-send-email-fweisbec@gmail.com>
Date: Wed, 16 Jan 2013 22:04:43 +0900
In-Reply-To: <1358339577-28766-1-git-send-email-fweisbec@gmail.com> (Frederic
	Weisbecker's message of "Wed, 16 Jan 2013 13:32:57 +0100")
Message-ID: <87wqvdl1n8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Wed, 16 Jan 2013 13:32:57 +0100, Frederic Weisbecker wrote:
> This subsystem lacks many explanations on its purpose and
> design. Add these missing comments.
>
> v3: Fix the "hook" based naming as per Ingo's suggestion
[snip]
> +/**
> + * context_tracking_task_switch - context switch the syscall callbacks

To be more kernel-doc-friendly, it'd better adding descriptions for
arguments too:

 @prev: the task that is being switched out
 @next: the task we are going to switch to

Thanks,
Namhyung


> + *
> + * The context tracking uses the syscall slow path to implement its user-kernel
> + * boundaries probes on syscalls. This way it doesn't impact the syscall fast
> + * path on CPUs that don't do context tracking.
> + *
> + * But we need to clear the flag on the previous task because it may later
> + * migrate to some CPU that doesn't do the context tracking. As such the TIF
> + * flag may not be desired there.
> + */
>  void context_tracking_task_switch(struct task_struct *prev,
>  			     struct task_struct *next)
>  {
