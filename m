Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3LJV0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:26:52 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47427 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3LJV0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:26:50 -0500
MIME-Version: 1.0
In-Reply-To: <20131210105820.GC12849@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
	<tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
	<CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
	<20131121150344.GG10022@twins.programming.kicks-ass.net>
	<CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
	<CAE9FiQUCPvzeiCSan34aV6hfrDHdV=sfHug0tMaAgpOMbum7jw@mail.gmail.com>
	<alpine.DEB.2.02.1311271902230.5120@chino.kir.corp.google.com>
	<CAE9FiQUVLT3PL3ON_VRrNB6p9TxFU_-X_dkcb6dLvzonmmW7ag@mail.gmail.com>
	<CAE9FiQW53FvCUGnax0CVdrWL8wqd4wweEfQVZgJciivAYaD1yw@mail.gmail.com>
	<20131210105820.GC12849@twins.programming.kicks-ass.net>
Date: Tue, 10 Dec 2013 13:26:50 -0800
X-Google-Sender-Auth: vSPx7elDq5dMgojvlKqrW4VBo60
Message-ID: <CAE9FiQVmF6Ho-+p1gncxJR_eM7Wg-c9c7tN-e+YWMs5PKkAYVA@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 2:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> Ooh, sg_capacity() is generating the /0..
>
> Does the below work too?
>
> ---
>  kernel/sched/core.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 87c3bc47d99d..40b185f5a3ec 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5115,6 +5115,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
>                  * die on a /0 trap.
>                  */
>                 sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sg_span);
> +               sg->sgp->power_orig = sg->sgp->power;
>
>                 /*
>                  * Make sure the first group of this domain contains the


Yes, it works.
