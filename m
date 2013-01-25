Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3AYHTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:19:41 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53748 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3AYHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:19:37 -0500
Date: Fri, 25 Jan 2013 08:19:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2] sched: Fix print format for u64
Message-ID: <20130125071933.GA17846@gmail.com>
References: <1356434680-10045-1-git-send-email-festevam@gmail.com>
 <CAOMZO5AzJUvrc5LcNyqPbEz0g4U5KZAXrNK8oJUiht=fdyuc5g@mail.gmail.com>
 <20130124141930.GA14881@gmail.com>
 <CAOMZO5CC76Md9T=2z3RWi4GrKsUuFcc8VYV1QfmZWF41vnOhVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CC76Md9T=2z3RWi4GrKsUuFcc8VYV1QfmZWF41vnOhVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fabio Estevam <festevam@gmail.com> wrote:

> On Thu, Jan 24, 2013 at 12:19 PM, Ingo Molnar <mingo@kernel.org> wrote:
> 
> > I suppose - is this patch warning-free both on 64-bit and 32-bit
> > systems?
> 
> Yes, just confirmed that this patch is warning-free on both 64-bit and
> 32-bit machines.

Apparently it's not all good, see the warning attached below.

Thanks,

	Ingo

----- Forwarded message from kbuild test robot <fengguang.wu@intel.com> -----

Date: Fri, 25 Jan 2013 14:02:05 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Ingo Molnar <mingo@kernel.org>
Subject: [next:akpm 188/817] kernel/sched/debug.c:225:2: warning: format '%llu' expects argument
	of type 'long long unsigned int', but argument 4 has type 'long int'

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
head:   5d2ee7d8b03bfe3b90325d736d8e544d0394efa7
commit: 2d58000fd2020255af63ee92c8d0ef615f6c4ade [188/817] sched: Fix print format for u64
config: make ARCH=x86_64 allmodconfig

All warnings:

   kernel/sched/debug.c: In function 'print_cfs_rq':
>> kernel/sched/debug.c:225:2: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 4 has type 'long int' [-Wformat]
>> kernel/sched/debug.c:225:2: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 3 has type 'long int' [-Wformat]

vim +225 kernel/sched/debug.c

   209		spread = max_vruntime - MIN_vruntime;
   210		SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread",
   211				SPLIT_NS(spread));
   212		spread0 = min_vruntime - rq0_min_vruntime;
   213		SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
   214				SPLIT_NS(spread0));
   215		SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
   216				cfs_rq->nr_spread_over);
   217		SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
   218		SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
   219	#ifdef CONFIG_FAIR_GROUP_SCHED
   220	#ifdef CONFIG_SMP
   221		SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
   222				cfs_rq->runnable_load_avg);
   223		SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
   224				cfs_rq->blocked_load_avg);
 > 225		SEQ_printf(m, "  .%-30s: %llu\n", "tg_load_avg",
   226				atomic64_read(&cfs_rq->tg->load_avg));
   227		SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
   228				cfs_rq->tg_load_contrib);
   229		SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
   230				cfs_rq->tg_runnable_contrib);
   231		SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
   232				atomic_read(&cfs_rq->tg->runnable_avg));
   233	#endif

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

----- End forwarded message -----

