Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3LDL0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:26:09 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33033 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3LDL0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:26:07 -0500
Message-ID: <529F1111.2010808@linaro.org>
Date: Wed, 04 Dec 2013 19:25:05 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com,
        james.hogan@imgtec.com, jason.low2@hp.com, gregkh@linuxfoundation.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org> <1386061556-28233-5-git-send-email-alex.shi@linaro.org> <20131204090615.GA5135@yliu-dev.sh.intel.com>
In-Reply-To: <20131204090615.GA5135@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We obsevered 150% performance gain with vm-scalability/300s-mmap-pread-seq
> testcase with this patch applied. Here is a list of changes we got so far:
> 
> testbox : brickland

got some explain of brickland on wiki:
High-end server platform based on the Ivy Bridge-EX processor
> testcase: vm-scalability/300s-mmap-pread-seq

https://github.com/aristeu/vm-scalability

Thanks a lot for testing! :)
Do you have data of base upstream commit?

> 
> 
>     f1b6442c7dd12802e622      d70495ef86f397816d73  
>        (parent commit)            (this commit)
> ------------------------  ------------------------  
>              26393249.80      +150.9%  66223933.60  vm-scalability.throughput
> 
>                   225.12       -49.9%       112.75  time.elapsed_time
>                 36333.40       -90.7%      3392.20  vmstat.system.cs
>                     2.40      +375.0%        11.40  vmstat.cpu.id
>               3770081.60       -97.7%     87673.40  time.major_page_faults
>               3975276.20       -97.0%    117409.60  time.voluntary_context_switches
>                     3.05      +301.7%        12.24  iostat.cpu.idle
>                 21118.41       -70.3%      6277.19  time.system_time
>                    18.40      +130.4%        42.40  vmstat.cpu.us
>                    77.00       -41.3%        45.20  vmstat.cpu.sy
>                 47459.60       -31.3%     32592.20  vmstat.system.in
>                 82435.40       -12.1%     72443.60  time.involuntary_context_switches
>                  5128.13       +14.0%      5848.30  time.user_time
>                 11656.20        -7.8%     10745.60  time.percent_of_cpu_this_job_got
>            1069997484.80        +0.3% 1073679919.00 time.minor_page_faults
> 

-- 
Thanks
    Alex
