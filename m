Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaBKEIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 23:08:05 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:41201 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaBKEIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 23:08:01 -0500
Message-ID: <52F9A1D8.7040301@huawei.com>
Date: Tue, 11 Feb 2014 12:06:48 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [question] how to figure out OOM reason? should dump slab/vmalloc
 info when OOM?
References: <52DCFC33.80008@huawei.com> <alpine.DEB.2.02.1401202130590.21729@chino.kir.corp.google.com> <52DE6AA0.1000801@huawei.com> <alpine.DEB.2.02.1401211236520.10355@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401211236520.10355@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.155]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/22 4:41, David Rientjes wrote:

> On Tue, 21 Jan 2014, Jianguo Wu wrote:
> 
>>> The problem is that slabinfo becomes excessively verbose and dumping it 
>>> all to the kernel log often times causes important messages to be lost.  
>>> This is why we control things like the tasklist dump with a VM sysctl.  It 
>>> would be possible to dump, say, the top ten slab caches with the highest 
>>> memory usage, but it will only be helpful for slab leaks.  Typically there 
>>> are better debugging tools available than analyzing the kernel log; if you 
>>> see unusually high slab memory in the meminfo dump, you can enable it.
>>>
>>
>> But, when OOM has happened, we can only use kernel log, slab/vmalloc info from proc
>> is stale. Maybe we can dump slab/vmalloc with a VM sysctl, and only top 10/20 entrys?
>>
> 
> You could, but it's a tradeoff between how much to dump to a general 
> resource such as the kernel log and how many sysctls we add that control 
> every possible thing.  Slab leaks would definitely be a minority of oom 
> conditions and you should normally be able to reproduce them by running 
> the same workload; just use slabtop(1) or manually inspect /proc/slabinfo 
> while such a workload is running for indicators.  I don't think we want to 
> add the information by default, though, nor do we want to add sysctls to 
> control the behavior (you'd still need to reproduce the issue after 
> enabling it).
> 
> We are currently discussing userspace oom handlers, though, that would 
> allow you to run a process that would be notified and allowed to allocate 
> a small amount of memory on oom conditions.  It would then be trivial to 
> dump any information you feel pertinent in userspace prior to killing 
> something.  I like to inspect heap profiles for memory hogs while 
> debugging our malloc() issues, for example, and you could look more 
> closely at kernel memory.
> 
> I'll cc you on future discussions of that feature.
> 

Hi David,

Thanks for your kindly explanation, do you have any specific plans on this?

Thanks,
Jianguo Wu.

> 



