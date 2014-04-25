Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaDYElN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 00:41:13 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37285 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaDYElL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 00:41:11 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1404242201190.6086@math.ut.ee>
References: <alpine.SOC.1.00.1404241249480.13595@math.ut.ee>
	<CAKohpoktwh=SgHTfEgT7vYRVWHssXw7==+a9qAdtmJXepjT2Tw@mail.gmail.com>
	<alpine.SOC.1.00.1404241316290.13595@math.ut.ee>
	<5358EBB9.3090809@linux.vnet.ibm.com>
	<alpine.SOC.1.00.1404242201190.6086@math.ut.ee>
Date: Fri, 25 Apr 2014 10:11:10 +0530
Message-ID: <CAKohpom5K0ZdCxqyArVNbDSrf824__izwjBNq+Xb9RGB-pqnag@mail.gmail.com>
Subject: Re: 3.15-rc2: longhaul cpufreq stalls tasks for 120s+
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Meelis Roos <mroos@linux.ee>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2014 00:33, Meelis Roos <mroos@linux.ee> wrote:

> [  240.140176] INFO: task kworker/0:1:116 blocked for more than 120 seconds.
> [  240.140353]       Not tainted 3.15.0-rc2-dirty #37
> [  240.140485] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.140687] kworker/0:1     D cf6afd50     0   116      2 0x00000000
> [  240.140938] Workqueue: events od_dbs_timer
> [  240.141103]  cf6afd98 00000082 00000002 cf6afd50 c1040d91 cf6affec cf6ad310 cf6ad310
> [  240.142479]  c1286dcb 00000002 cf6afd70 c1040f14 00000000 ce460b30 00000282 00000046
> [  240.143011]  00000282 ce460b30 cf6afd78 c1040f39 cf6afd88 00000282 cf6afdb0 ce460b30
> [  240.143544] Call Trace:
> [  240.143706]  [<c1040d91>] ? mark_held_locks+0x4b/0x61
> [  240.143883]  [<c1286dcb>] ? _raw_spin_unlock_irqrestore+0x33/0x3f
> [  240.144043]  [<c1040f14>] ? trace_hardirqs_on_caller+0x16d/0x187
> [  240.144203]  [<c1040f39>] ? trace_hardirqs_on+0xb/0xd
> [  240.144358]  [<c1284145>] schedule+0x5d/0x5f
> [  240.144527]  [<c11eaa67>] cpufreq_freq_transition_begin+0x4a/0x9d
> [  240.144687]  [<c103e1b0>] ? __wake_up_sync+0x14/0x14
> [  240.144860]  [<d06722d5>] longhaul_setstate+0x88/0x2f1 [longhaul]
> [  240.145023]  [<c1036d43>] ? srcu_notifier_call_chain+0x1a/0x1c
> [  240.145186]  [<c11eaab2>] ? cpufreq_freq_transition_begin+0x95/0x9d
> [  240.145350]  [<d06725ba>] longhaul_target+0x7c/0x8b [longhaul]
> [  240.145511]  [<c11eae78>] __cpufreq_driver_target+0xfe/0x148

Am I reading it correctly? It looks like we are starting another transition
from notifier chain, but I couldn't figure out how from code.
