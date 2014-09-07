Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaIGO3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 10:29:40 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41528 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaIGO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 10:29:38 -0400
Message-ID: <540C6BCD.70504@linaro.org>
Date: Sun, 07 Sep 2014 07:29:33 -0700
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Abel Vesa <abelvesa@gmail.com>, alex.shi@intel.com,
        vincent.guittot@linaro.org, peterz@infradead.org, pjt@google.com,
        efault@gmx.de, rjw@rjwysocki.net, morten.rasmussen@arm.com,
        svaidy@linux.vnet.ibm.com, arjan@linux.intel.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com
CC: linaro-kernel@lists.linaro.org, corbet@lwn.net, catalin.marinas@arm.com,
        markgross@thegnar.org, sundar.iyer@intel.com,
        linux-kernel@vger.kernel.org, mike.turquette@linaro.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        dietmar.eggemann@arm.com
Subject: Re: Power Scheduler Design
References: <20140907114705.GA10470@abel-laptop>
In-Reply-To: <20140907114705.GA10470@abel-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 9/7/14, 4:47, Abel Vesa 写道:
> For a while now, I've started studying the power aware scheduling problem.
> And like many other rookies out there I took all the lkml mails related
> and read them all (well, almost all) and I saw that there are some
> debating on the implementation.I even look over the implementation
> proposed of Preeti U Murthy. I also worked (just for fun) for a while on
> some ideas of my own (nothing worth sharing, yet) but I have problem
> understanding the design requirements. Here is one.
>
>    Some of you (even Ingo) said  that the scheduler should be the one to
> manage the cpu P/C states. In this case the governors of the cpuidle and
> cpufreq would not make any sense anymore.  Does that mean they will not
> be a part of this scheduling solution anymore?
CPUIDLE and CPUFREQ are used for cpu power saving when related CPU is 
not busy.
Scheduling is coordinate the system load and cpu load. Currently. 
Scheduling has no much
idea of CPUIDLE/CPUFREQ status, then may give task to a cpu which in 
poor latency or poor
powersaving status. That leads to poor latency and high cost of power.

The power aware scheduling target is to know and coordinate the 
cpuidle/cpufreq in scheduling.
Then tasks will be assigned to a cpu unit with better 
latency/powersaving consideration.

>
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel

