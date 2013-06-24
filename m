Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab3FXDQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 23:16:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:61410 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab3FXDQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 23:16:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,925,1363158000"; 
   d="scan'208";a="321482898"
Message-ID: <51C7B9B8.6090309@intel.com>
Date: Mon, 24 Jun 2013 11:15:04 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org
CC: tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 10:18 AM, Alex Shi wrote:
> Resend patchset for more convenient pick up.
> This patch set combine 'use runnable load in balance' serials and 'change 
> 64bit variables to long type' serials. also collected Reviewed-bys, and 
> Tested-bys.
> 
> The only changed code is fixing load to load_avg convert in UP mode, which
> found by PeterZ in task_h_load().
> 
> Paul still has some concern of blocked_load_avg out of balance consideration.
> but I didn't see the blocked_load_avg usage was thought through now, or some 
> strong reason to make it into balance.
> So, according to benchmarks testing result I keep patches unchanged.

Ingo & Peter,

This patchset was discussed spread and deeply.

Now just 6th/8th patch has some arguments on them, Paul think it is
better to consider blocked_load_avg in balance, since it is helpful on
some scenarios, but I think on most of scenarios, the blocked_load_avg
just cause load imbalance among cpus. and plus testing show with
blocked_load_avg the performance is just worse on some benchmarks. So, I
still prefer to keep it out of balance.

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg455196.html

Is it the time to do the decision or give more comments? Thanks!
> 
> Regards
> Alex
> 
> [Resend patch v8 01/13] Revert "sched: Introduce temporary
> [Resend patch v8 02/13] sched: move few runnable tg variables into
> [Resend patch v8 03/13] sched: set initial value of runnable avg for
> [Resend patch v8 04/13] sched: fix slept time double counting in
> [Resend patch v8 05/13] sched: update cpu load after task_tick.
> [Resend patch v8 06/13] sched: compute runnable load avg in cpu_load
> [Resend patch v8 07/13] sched: consider runnable load average in
> [Resend patch v8 08/13] sched/tg: remove blocked_load_avg in balance
> [Resend patch v8 09/13] sched: change cfs_rq load avg to unsigned
> [Resend patch v8 10/13] sched/tg: use 'unsigned long' for load
> [Resend patch v8 11/13] sched/cfs_rq: change atomic64_t removed_load
> [Resend patch v8 12/13] sched/tg: remove tg.load_weight
> [Resend patch v8 13/13] sched: get_rq_runnable_load() can be static
> 


-- 
Thanks
    Alex
