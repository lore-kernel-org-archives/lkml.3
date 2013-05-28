Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185Ab3E1NbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:31:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:21755 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934144Ab3E1NbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:31:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,758,1363158000"; 
   d="scan'208";a="344368181"
Message-ID: <51A4B19A.5090500@intel.com>
Date: Tue, 28 May 2013 21:31:06 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        peterz@infradead.org, pjt@google.com
CC: tglx@linutronix.de, akpm@linux-foundation.org, bp@alien8.de,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch 0/8]: use runnable load avg in balance
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <51948AD4.3020104@linux.vnet.ibm.com>
In-Reply-To: <51948AD4.3020104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 03:29 PM, Michael Wang wrote:
>> > This version changed the runnable load avg value setting for new task
>> > in patch 3rd.
>> > 
>> > We also tried to include blocked load avg in balance. but find many benchmark
>> > performance dropping. Guess the too bigger cpu load drive task to be waken
>> > on remote CPU, and cause wrong decision in periodic balance.
>> > 
>> > I retested on Intel core2, NHM, SNB, IVB, 2 and 4 sockets machines with
>> > benchmark kbuild, aim7, dbench, tbench, hackbench, oltp, and netperf loopback
>> > etc. The performance is better now. 
>> > 
>> > On SNB EP 4 sockets machine, the hackbench increased about 50%, and result
>> > become stable. on other machines, hackbench increased about 2~10%.
>> > oltp increased about 30% in NHM EX box.
>> > netperf loopback also increased on SNB EP 4 sockets box.
>> > no clear changes on other benchmarks.
>> > 
>> > Michael Wang had tested previous version on pgbench on his box:
>> > https://lkml.org/lkml/2013/4/2/1022
> Tested the latest patch set (new 3/8 and 6/8) with pgbench, tip
> 3.10.0-rc1 and 12 cpu X86 box, works well and still benefit ;-)


Paul:

Would you like to give more comments/ideas of this patch set?

-- 
Thanks
    Alex
