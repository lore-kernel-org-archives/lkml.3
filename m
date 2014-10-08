Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaJHMyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:54:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37022 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaJHMyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:54:46 -0400
Message-ID: <54353422.3070002@arm.com>
Date: Wed, 08 Oct 2014 13:54:58 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Yuyang Du <yuyang.du@intel.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com> <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com> <20141008005007.GA7017@intel.com>
In-Reply-To: <20141008005007.GA7017@intel.com>
X-OriginalArrivalTime: 08 Oct 2014 12:54:43.0560 (UTC) FILETIME=[07F91E80:01CFE2F7]
X-MC-Unique: 114100813544400301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuyang,

On 08/10/14 01:50, Yuyang Du wrote:
> Hi Morten,
> 
> Sorry for late jumping in.
> 
> The problem seems to be self-evident. But for the implementation to be
> equally attractive it needs to account for every freq change for every task,
> or anything less than that makes it less attractive.
> 
> But this should be very hard. Intel Architecture has limitation to capture all
> the freq changes in software and also the intel_pstate should have no
> notification.

We encountered this missing notification for current frequency with
Intel systems (e.g. i5-3320M) using the intel_pstate driver while
testing this patch-set. The arch_scale_set_curr_freq call in
__cpufreq_notify_transition [[PATCH 2/7] cpufreq: Architecture specific
callback for frequency changes] will not work on such a system.

In our internal testing, we placed arch_scale_set_curr_freq(cpu->cpu,
sample->freq) into intel_pstate_timer_func [intel_pstate.c] to get the
current frequency for a cpu.

The arch_scale_set_max_freq call in cpufreq_set_policy
[drivers/cpufreq/cpufreq.c] still works although the driver exposes the
max turbo pstate and not the max pstate. That's an additional problem
because we don't want to use turbo states for frequency scaling.

> 
> For every task, this makes the updating of the entire queue in load tracking
> more needed, so once again, ping maintainers for the rewrite patches, :)
> 
> Thanks,
> Yuyang
> 

[...]

