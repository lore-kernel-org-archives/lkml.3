Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab3BYJxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:53:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:52911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab3BYJxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:53:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,733,1355126400"; 
   d="scan'208";a="267173366"
Message-ID: <512B3498.6030401@intel.com>
Date: Mon, 25 Feb 2013 17:53:28 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in fork/exec/wake
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>  <1361164062-20111-10-git-send-email-alex.shi@intel.com>  <1361353360.10155.9.camel@laptop> <5124BCEB.8030606@intel.com>  <1361367371.10155.32.camel@laptop> <5124DC76.2010801@intel.com>  <1361453587.26780.18.camel@laptop> <512631C7.8060103@intel.com>  <1361523279.26780.45.camel@laptop> <5129DD1A.8070509@intel.com>  <512A5332.6040507@linux.vnet.ibm.com> <512ACB39.1010605@intel.com> <1361762585.4555.28.camel@marge.simpson.net>
In-Reply-To: <1361762585.4555.28.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 11:23 AM, Mike Galbraith wrote:
> On Mon, 2013-02-25 at 10:23 +0800, Alex Shi wrote:
> 
>> One of problem is the how to decide the criteria of the burst? If we set
>> 5 waking up/ms is burst, we will lose 4 waking up/ms.
>> another problem is the burst detection cost, we need tracking a period
>> history info of the waking up, better on whole group. but that give the
>> extra cost in burst.
>>
>> solution candidates:
>> https://lkml.org/lkml/2013/1/21/316
>> After talk with MikeG, I remove the runnable load avg in performance
>> load balance.
> 
> One thing you could try is to make criteria depend on avg_idle.  It will
> slam to 2*migration_cost when a wakeup arrives after an ~extended idle.
> You could perhaps extend it to cover new task wakeup as well, and use
> that transition to invalidate history, switch to instantaneous until
> fresh history can accumulate.

Sorry for can not get your points, would you like to goes to details?

And still don't understand of the idle_stamp setting, idle_stamp was set
in idle_balance(), if idle_balance doesn't pulled task, idle_stamp value
kept. then even the cpu get tasks from another balancing, like periodic
balance, fork/exec/wake balancing, the idle_stamp is still kept.

So, when the cpu goes to next idle_balance(), it's highly possible to
meet the avg_idle > migration_cost condition, and start try to pull
tasks, nearly unconditionally.

Does the idle_balance was designed to this? or we still should reset
idle_stamp whichever we pulled a task?

> 
> -Mike
> 


-- 
Thanks Alex
