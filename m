Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab3LKE5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 23:57:48 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:33432 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3LKE5p (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Tue, 10 Dec 2013 23:57:45 -0500
Message-ID: <52A7F0C6.7060405@symas.com>
Date: Tue, 10 Dec 2013 20:57:42 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24a1
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: Re: sched: RT throttling activated, 3.12.3
References: <52A7D512.5050801@symas.com> <52A7D5E5.3070704@huawei.com> <52A7D74D.7000804@symas.com>
In-Reply-To: <52A7D74D.7000804@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howard Chu wrote:
> Li Zefan wrote:
>> On 2013/12/11 10:59, Howard Chu wrote:
>>> I just upgraded a system from a 3.5 kernel to 3.12.3 and attempted to run some new benchmarks on it. I see my test program ramps up in CPU usage for a few seconds and then it gradually tails off. There's nothing obvious in the user code to trigger this behavior, so I check dmesg, and see this:
>>>
>>> [   55.037057] JFS: nTxBlock = 8192, nTxLock = 65536
>>> [163591.807470] perf samples too long (2758 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
>>> [164061.362762] perf samples too long (5204 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
>>> [167969.339513] [sched_delayed] sched: RT throttling activated
>>> [182741.484637] perf samples too long (294588 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
>>> [182741.484726] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 36.665 msecs
>>> [182822.633084] perf samples too long (292359 > 20000), lowering kernel.perf_event_max_sample_rate to 6250
>>> [182905.606119] perf samples too long (290291 > 40000), lowering kernel.perf_event_max_sample_rate to 3250
>>> [199384.293514] perf samples too long (288142 > 76923), lowering kernel.perf_event_max_sample_rate to 1750
>>> [208507.301027] perf samples too long (285964 > 142857), lowering kernel.perf_event_max_sample_rate to 1000
>>> [208528.976208] perf samples too long (283799 > 250000), lowering kernel.perf_event_max_sample_rate to 500
>>>
>>> Why is the kernel throttling my server?
>>>
>>
>> Because that is the default setting of the kernel.
>
> Apparently a "new" default that didn't exist in 3.5? The code in question is
> not a realtime process. This behavior also wasn't seen in 3.10 or any older
> kernels.

I just downgraded to 3.10.23 to doublecheck - everything is running normally 
there, although a few percent slower than I expected. (Last time I tried 3.10 
it was 3.10.11.)

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
