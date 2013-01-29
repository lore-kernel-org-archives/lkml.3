Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3A2GBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:01:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:13193 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3A2GBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:01:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,557,1355126400"; 
   d="scan'208";a="283399190"
Message-ID: <510765F6.9040203@intel.com>
Date: Tue, 29 Jan 2013 14:02:30 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com> <510493E4.8060602@intel.com> <20130127104039.GC8894@pd.tnic> <51060A6D.4090208@intel.com>
In-Reply-To: <51060A6D.4090208@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 01:19 PM, Alex Shi wrote:
> On 01/27/2013 06:40 PM, Borislav Petkov wrote:
>> On Sun, Jan 27, 2013 at 10:41:40AM +0800, Alex Shi wrote:
>>> Just rerun some benchmarks: kbuild, specjbb2005, oltp, tbench, aim9,
>>> hackbench, fileio-cfq of sysbench, dbench, aiostress, multhreads
>>> loopback netperf. on my core2, nhm, wsm, snb, platforms. no clear
>>> performance change found.
>>
>> Ok, good, You could put that in one of the commit messages so that it is
>> there and people know that this patchset doesn't cause perf regressions
>> with the bunch of benchmarks.
>>
>>> I also tested balance policy/powersaving policy with above benchmark,
>>> found, the specjbb2005 drop much 30~50% on both of policy whenever
>>> with openjdk or jrockit. and hackbench drops a lots with powersaving
>>> policy on snb 4 sockets platforms. others has no clear change.

Sorry, the testing configuration is unfair for this specjbb2005 results
here. I set JVM hard pin and use hugepage for peak performance.

When remove the hard pin and no hugepage, the balance/powersaving both
drop about 5% VS performance policy, and performance policy result is
similar with 3.8-rc5.

>>
>> I guess this is expected because there has to be some performance hit
>> when saving power...
>>
> 
> BTW, I had tested the v3 version based on sched numa -- on tip/master.
> The specjbb just has about 5~7% dropping on balance/powersaving policy.
> The power scheduling done after the numa scheduling logical.
> 


-- 
Thanks Alex
