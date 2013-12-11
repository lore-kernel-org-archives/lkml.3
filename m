Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3LKDDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:03:37 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:55178 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3LKDDe (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Tue, 10 Dec 2013 22:03:34 -0500
Message-ID: <52A7D5E5.3070704@huawei.com>
Date: Wed, 11 Dec 2013 11:03:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: Re: sched: RT throttling activated, 3.12.3
References: <52A7D512.5050801@symas.com>
In-Reply-To: <52A7D512.5050801@symas.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/11 10:59, Howard Chu wrote:
> I just upgraded a system from a 3.5 kernel to 3.12.3 and attempted to run some new benchmarks on it. I see my test program ramps up in CPU usage for a few seconds and then it gradually tails off. There's nothing obvious in the user code to trigger this behavior, so I check dmesg, and see this:
> 
> [   55.037057] JFS: nTxBlock = 8192, nTxLock = 65536
> [163591.807470] perf samples too long (2758 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> [164061.362762] perf samples too long (5204 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
> [167969.339513] [sched_delayed] sched: RT throttling activated
> [182741.484637] perf samples too long (294588 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
> [182741.484726] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 36.665 msecs
> [182822.633084] perf samples too long (292359 > 20000), lowering kernel.perf_event_max_sample_rate to 6250
> [182905.606119] perf samples too long (290291 > 40000), lowering kernel.perf_event_max_sample_rate to 3250
> [199384.293514] perf samples too long (288142 > 76923), lowering kernel.perf_event_max_sample_rate to 1750
> [208507.301027] perf samples too long (285964 > 142857), lowering kernel.perf_event_max_sample_rate to 1000
> [208528.976208] perf samples too long (283799 > 250000), lowering kernel.perf_event_max_sample_rate to 500
> 
> Why is the kernel throttling my server?
> 

Because that is the default setting of the kernel.

lxc34:/proc/sys/kernel # cat sched_rt_period_us
1000000
lxc34:/proc/sys/kernel # cat sched_rt_runtime_us
950000

