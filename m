Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3BVCx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:53:29 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:36835 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3BVCxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:53:23 -0500
Message-ID: <5126DD98.7030202@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 10:53:12 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
References: <51079178.3070002@linux.vnet.ibm.com> <510791B2.6090506@linux.vnet.ibm.com> <1361366720.10155.25.camel@laptop> <5125A966.6040601@linux.vnet.ibm.com> <1361446661.26780.15.camel@laptop>
In-Reply-To: <1361446661.26780.15.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022202-2000-0000-0000-00000B0A9D98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 07:37 PM, Peter Zijlstra wrote:
> On Thu, 2013-02-21 at 12:58 +0800, Michael Wang wrote:
>>
>> You are right, it cost space in order to accelerate the system, I've
>> calculated the cost once before (I'm really not good at this, please
>> let
>> me know if I make any silly calculation...), 
> 
> The exact size isn't that important, but its trivial to see its quadric.
> You have a NR_CPUS array per-cpu, thus O(n^2).
> 
> ( side note; invest in getting good at complexity analysis -- or at
> least competent, its the single most important aspect of programming. )
> 
> ...
> 
>> And the final cost is 3000 int and 1030000 pointer, and some padding,
>> but won't bigger than 10M, not a big deal for a system with 1000 cpu
>> too.
> 
> Maybe, but quadric stuff should be frowned upon at all times, these
> things tend to explode when you least expect it.
> 
> For instance, IIRC the biggest single image system SGI booted had 16k
> cpus in there, that ends up at something like 14+14+3=31 aka as 2G of
> storage just for your lookup -- that seems somewhat preposterous.

Honestly, if I'm a admin who own 16k cpus system (I could not even image
how many memory it could have...), I really prefer to exchange 2G memory
to gain some performance.

I see your point here, the cost of space will grow exponentially, but
the memory of system will also grow, and according to my understanding ,
it's faster.

Regards,
Michael Wang

> 
> The domain levels are roughly O(log n) related to the total cpus, so
> what you're doing is replacing an O(log n) lookup with an O(1) lookup,
> but at the cost of O(n^2) storage. 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

