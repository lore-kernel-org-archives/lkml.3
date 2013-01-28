Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab3A1Fu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:50:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:59317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab3A1Fu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:50:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,550,1355126400"; 
   d="scan'208";a="277318567"
Message-ID: <510611D2.1020007@intel.com>
Date: Mon, 28 Jan 2013 13:51:14 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>  <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>  <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>  <1359301903.5805.11.camel@marge.simpson.net> <1359350266.5783.39.camel@marge.simpson.net>
In-Reply-To: <1359350266.5783.39.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 01:17 PM, Mike Galbraith wrote:
> On Sun, 2013-01-27 at 16:51 +0100, Mike Galbraith wrote: 
>> On Sun, 2013-01-27 at 21:25 +0800, Alex Shi wrote: 
>>> On 01/27/2013 06:35 PM, Borislav Petkov wrote:
>>>> On Sun, Jan 27, 2013 at 05:36:25AM +0100, Mike Galbraith wrote:
>>>>> With aim7 compute on 4 node 40 core box, I see stable throughput
>>>>> improvement at tasks = nr_cores and below w. balance and powersaving. 
>> ... 
>>>> Ok, this is sick. How is balance and powersaving better than perf? Both
>>>> have much more jobs per minute than perf; is that because we do pack
>>>> much more tasks per cpu with balance and powersaving?
>>>
>>> Maybe it is due to the lazy balancing on balance/powersaving. You can
>>> check the CS times in /proc/pid/status.
>>
>> Well, it's not wakeup path, limiting entry frequency per waker did zip
>> squat nada to any policy throughput.
> 
> monteverdi:/abuild/mike/:[0]# echo powersaving > /sys/devices/system/cpu/sched_policy/current_sched_policy
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 043321  00058616
> 043313  00058616
> 043318  00058968
> 043317  00058968
> 043316  00059184
> 043319  00059192
> 043320  00059048
> 043314  00059048
> 043312  00058176
> 043315  00058184
> monteverdi:/abuild/mike/:[0]# echo balance > /sys/devices/system/cpu/sched_policy/current_sched_policy
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 043337  00053448
> 043333  00053456
> 043338  00052992
> 043331  00053448
> 043332  00053488
> 043335  00053496
> 043334  00053480
> 043329  00053288
> 043336  00053464
> 043330  00053496
> monteverdi:/abuild/mike/:[0]# echo performance > /sys/devices/system/cpu/sched_policy/current_sched_policy
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 043348  00052488
> 043344  00052488
> 043349  00052744
> 043343  00052504
> 043347  00052504
> 043352  00052888
> 043345  00052504
> 043351  00052496
> 043346  00052496
> 043350  00052304
> monteverdi:/abuild/mike/:[0]#

similar with aim7 results. Thanks, Mike!

Wold you like to collect vmstat info in background?
> 
> Zzzt.  Wish I could turn turbo thingy off.

Do you mean the turbo mode of cpu frequency? I remember some of machine
can disable it in BIOS.
> 
> -Mike
> 


-- 
Thanks Alex
