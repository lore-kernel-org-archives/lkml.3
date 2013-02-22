Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3BVETn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:19:43 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51383 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3BVETl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:19:41 -0500
Message-ID: <5126F1D4.5030308@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 12:19:32 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
References: <51079178.3070002@linux.vnet.ibm.com> <510791B2.6090506@linux.vnet.ibm.com> <1361366720.10155.25.camel@laptop> <5125A966.6040601@linux.vnet.ibm.com> <1361446661.26780.15.camel@laptop> <5126DD98.7030202@linux.vnet.ibm.com> <5126E705.3040308@intel.com>
In-Reply-To: <5126E705.3040308@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022204-5564-0000-0000-000006B75BE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 11:33 AM, Alex Shi wrote:
> On 02/22/2013 10:53 AM, Michael Wang wrote:
>>>>
>>>>>> And the final cost is 3000 int and 1030000 pointer, and some padding,
>>>>>> but won't bigger than 10M, not a big deal for a system with 1000 cpu
>>>>>> too.
>>>>
>>>> Maybe, but quadric stuff should be frowned upon at all times, these
>>>> things tend to explode when you least expect it.
>>>>
>>>> For instance, IIRC the biggest single image system SGI booted had 16k
>>>> cpus in there, that ends up at something like 14+14+3=31 aka as 2G of
>>>> storage just for your lookup -- that seems somewhat preposterous.
>> Honestly, if I'm a admin who own 16k cpus system (I could not even image
>> how many memory it could have...), I really prefer to exchange 2G memory
>> to gain some performance.
>>
>> I see your point here, the cost of space will grow exponentially, but
>> the memory of system will also grow, and according to my understanding ,
>> it's faster.
> 

Hi, Alex

Thanks for your reply.

> Why not seek other way to change O(n^2) to O(n)?
> 
> Access 2G memory is unbelievable performance cost.

Not access 2G memory, but (2G / 16K) memory, the sbm size is O(N).

And please notice that on 16k cpus system, topology will be deep if NUMA
enabled (O(log N) as Peter said), and that's really a good stage for
this idea to perform on, we could save lot's of recursed 'for' cycles.

> 
> There are too many jokes on the short-sight of compute scalability, like
> Gates' 64K memory in 2000.

Please do believe me that I won't give up any chance to solve or lighten
this issue (like apply Mike's suggestion), and please let me know if you
have any suggestions to reduce the memory cost.

May be I could make this idea as an option, override the
select_task_rq_fair() when people want the new logical, and if they
don't want to trade with memory, just !CONFIG.

Regards,
Michael Wang

> 

