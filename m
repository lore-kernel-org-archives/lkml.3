Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaEOMd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:33:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbaEOMd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:33:57 -0400
Date: Thu, 15 May 2014 14:33:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [uprobes/x86] 8ad8e9d3fd6: -7.5% aim7.2000.jobs-per-min,
	-45.7% turbostat.%c1
Message-ID: <20140515123332.GA15139@redhat.com>
References: <53743B03.7030404@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53743B03.7030404@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jet,

On 05/15, Jet Chen wrote:
>
> we noticed the below changes on
>
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 8ad8e9d3fd64f101eed6652964670672d699e563 ("uprobes/x86: Introduce uprobe_xol_ops and arch_uprobe->ops")
>
> Test case: lkp-snb01/aim7/signal_test
>
> 34e7317d6ae8f61  8ad8e9d3fd64f101eed665296
> ---------------  -------------------------
>     230689 ~ 0%      -7.5%     213485 ~ 0%  TOTAL aim7.2000.jobs-per-min
>       0.51 ~30%     -45.7%       0.28 ~10%  TOTAL turbostat.%c1
>        430 ~17%     +27.8%        549 ~15%  TOTAL vmstat.procs.r
>       0.83 ~14%     +38.1%       1.15 ~12%  TOTAL perf-profile.cpu-cycles.copy_pte_range.copy_page_range.copy_process.do_fork.sys_clone
>     106076 ~ 4%     +22.4%     129816 ~ 3%  TOTAL softirqs.RCU
>      12117 ~ 6%      -9.9%      10914 ~ 6%  TOTAL slabinfo.kmalloc-256.active_objs
>      32163 ~17%     +39.4%      44824 ~12%  TOTAL time.voluntary_context_switches
>     276487 ~ 1%     +16.5%     322091 ~ 1%  TOTAL time.involuntary_context_switches
>      83.14 ~ 0%     +13.3%      94.21 ~ 0%  TOTAL time.user_time
>     108800 ~ 2%      +9.4%     119014 ~ 3%  TOTAL time.minor_page_faults
>       1255 ~ 0%      +9.9%       1379 ~ 0%  TOTAL time.system_time
>       6774 ~ 1%      +8.8%       7373 ~ 1%  TOTAL vmstat.system.cs
>      52.15 ~ 0%      +8.0%      56.34 ~ 0%  TOTAL time.elapsed_time
>      25185 ~ 0%      +2.4%      25784 ~ 0%  TOTAL vmstat.system.in
>      79.23 ~ 0%      +2.0%      80.80 ~ 0%  TOTAL turbostat.%c0
>       2567 ~ 0%      +1.9%       2615 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
>        112 ~ 0%      +1.3%        113 ~ 0%  TOTAL turbostat.Cor_W
>        138 ~ 0%      +1.0%        139 ~ 0%  TOTAL turbostat.Pkg_W

Cough... this looks simply impossible ;)

Not only this patch "obviously can not" cause any noticable difference
performance-wise, the code changed by this patch is not executed unless
you play with uprobes?

Oleg.

