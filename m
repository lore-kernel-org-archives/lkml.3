Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaAUMk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 07:40:56 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:17504 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaAUMkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:40:53 -0500
Message-ID: <52DE6AA0.1000801@huawei.com>
Date: Tue, 21 Jan 2014 20:40:00 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [question] how to figure out OOM reason? should dump slab/vmalloc
 info when OOM?
References: <52DCFC33.80008@huawei.com> <alpine.DEB.2.02.1401202130590.21729@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401202130590.21729@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.155]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/21 13:34, David Rientjes wrote:

> On Mon, 20 Jan 2014, Jianguo Wu wrote:
> 
>> When OOM happen, will dump buddy free areas info, hugetlb pages info,
>> memory state of all eligible tasks, per-cpu memory info.
>> But do not dump slab/vmalloc info, sometime, it's not enough to figure out the
>> reason OOM happened.
>>
>> So, my questions are:
>> 1. Should dump slab/vmalloc info when OOM happen? Though we can get these from proc file,
>> but usually we do not monitor the logs and check proc file immediately when OOM happened.
>>
> 

Hi David,
Thank you for your patience to answer!

> The problem is that slabinfo becomes excessively verbose and dumping it 
> all to the kernel log often times causes important messages to be lost.  
> This is why we control things like the tasklist dump with a VM sysctl.  It 
> would be possible to dump, say, the top ten slab caches with the highest 
> memory usage, but it will only be helpful for slab leaks.  Typically there 
> are better debugging tools available than analyzing the kernel log; if you 
> see unusually high slab memory in the meminfo dump, you can enable it.
> 

But, when OOM has happened, we can only use kernel log, slab/vmalloc info from proc
is stale. Maybe we can dump slab/vmalloc with a VM sysctl, and only top 10/20 entrys?

Thanks.

>> 2. /proc/$pid/smaps and pagecache info also helpful when OOM, should also be dumped?

>>
> 
> Also very verbose and would cause important messages to be lost, we try to 
> avoid spamming the kernel log with all of this information as much as 
> possible.
> 
>> 3. Without these info, usually how to figure out OOM reason?
>>
> 
> Analyze the memory usage in the meminfo and determine what is unusually 
> high; if it's mostly anonymous memory, you can usually correlate it back 
> to a high rss for a process in the tasklist that you didn't suspect to be 
> using that much memory, for example.
> 
> 



