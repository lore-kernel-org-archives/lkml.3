Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab3GPPzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:55:25 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:49406 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3GPPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:55:24 -0400
MIME-Version: 1.0
In-Reply-To: <1373901620-2021-17-git-send-email-mgorman@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
	<1373901620-2021-17-git-send-email-mgorman@suse.de>
Date: Tue, 16 Jul 2013 23:55:24 +0800
Message-ID: <CAJd=RBAxApb2Hoz06_7Ry1Z-TSAWGp9QJCfLP5NPPm2kiUF+Bg@mail.gmail.com>
Subject: Re: [PATCH 16/18] sched: Avoid overloading CPUs on a preferred NUMA node
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:20 PM, Mel Gorman <mgorman@suse.de> wrote:
> +
> +static int task_numa_find_cpu(struct task_struct *p, int nid)
> +{
> +       int node_cpu = cpumask_first(cpumask_of_node(nid));
[...]
>
> +       /* No harm being optimistic */
> +       if (idle_cpu(node_cpu))
> +               return node_cpu;
>
[...]
> +       for_each_cpu(cpu, cpumask_of_node(nid)) {
> +               dst_load = target_load(cpu, idx);
> +
> +               /* If the CPU is idle, use it */
> +               if (!dst_load)
> +                       return dst_cpu;
> +
Here you want cpu, instead of dst_cpu, I guess.
