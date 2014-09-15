Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaIOPe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:34:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38766 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaIOPe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:34:56 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e1-5417071d5db4
Message-id: <5417058E.1010206@samsung.com>
Date: Mon, 15 Sep 2014 19:28:14 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.0
MIME-version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Michal Marek <mmarek@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC/PATCH v2 01/10] Add kernel address sanitizer infrastructure.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-2-git-send-email-a.ryabinin@samsung.com>
 <5414F0F3.4000001@infradead.org>
In-reply-to: <5414F0F3.4000001@infradead.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t/xq7qy7OIhBs8+21j83juT1WLO+jVs
	FkeufWe3uP7tDaPFp5cPGC2eP3zIbjHhYRu7xbSN4hYru5vZLLY/e8tksbLzAavF5V1z2Czu
	rfnPanHpwAImi5Z9F5gsjvceYLJ4e2c6i8XiI7eZLd49m8xscXXVQXaLHxseszqIeszf+ZHR
	Y+esu+weCzaVemxeoeWxeM9LJo9NqzrZPDZ9msTu0fX2CpPHiRm/WTyeXJnO5PHx6S0Wj/f7
	rrJ5nFlwhN3j8yY5jxMtX1gD+KO4bFJSczLLUov07RK4Mv5Mf8NW8E6gYt6GmWwNjKd4uhg5
	OSQETCQazy9igbDFJC7cW8/WxcjFISSwlFFixdxLUE4zk0Tr5x5WkCpeAS2J162L2UBsFgFV
	iflN3xhBbDYBPYl/s7aDxUUFIiSm7F8KVS8o8WPyPaANHBwiAm4SG88ZgISZBTaySvxYZwNi
	Cwv4SRxaNQtq1yNGiVO37zKDJDgFdCU+TZgG1ssMNP/+RS2IXnmJzWveMk9gFJiFZMMshKpZ
	SKoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJ5q87GJceszrEKMDBqMTDO2OjWIgQ
	a2JZcWXuIUYJDmYlEV7eX0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjE7pB7bO+3H5/rKd5t5L
	/DVMa1fqrDnDu8n8Obt1slbMs2O9sjdzu0RzD7J27SjqZNh4tFCebZ16jciyXYq1d11WHNVe
	vzQ0skx9Xb+b1lMuHiVRXtMU7s9T3rXYcCXcy3De77l2QYrNkjhOkU8mX7xddpw8YxqdW2vB
	51e68sPPm6YHeianK7EUZyQaajEXFScCAA2c1qPEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2014 05:35 AM, Randy Dunlap wrote:
> Following sentence is confusing.  I'm not sure how to fix it.
> 


Perhaps rephrase is like this:

Do not use slub poisoning with KASan if user tracking enabled (iow slub_debug=PU).
User tracking info (allocation/free stacktraces) are stored inside slub object's metadata.
Slub poisoning overwrites slub object and it's metadata with poison value on freeing.
So if KASan will detect use after free, allocation/free stacktraces will be overwritten
and KASan won't be able to print them.


>> +Please don't use slab poisoning with KASan (slub_debug=P), beacuse if KASan will
> 
>                                                                          drop: will
> 
>> +detects use after free allocation and free stacktraces will be overwritten by
> 
> maybe:     use after free,
> 
>> +poison bytes, and KASan won't be able to print this backtraces.
> 
>                                                        backtrace.
> 
>> +
>> +Each shadow byte corresponds to 8 bytes of the main memory. We use the
>> +following encoding for each shadow byte: 0 means that all 8 bytes of the
>> +corresponding memory region are addressable; k (1 <= k <= 7) means that
>> +the first k bytes are addressable, and other (8 - k) bytes are not;
>> +any negative value indicates that the entire 8-byte word is unaddressable.
>> +We use different negative values to distinguish between different kinds of
>> +unaddressable memory (redzones, freed memory) (see mm/kasan/kasan.h).
>> +
> 
> Is there any need for something similar to k (1 <= k <= 7) but meaning that the
> *last* k bytes are addressable instead of the first k bytes?
> 

There is no need for that. Slub allocations are always 8 byte aligned (at least on 64bit systems).
Now I realized that it could be a problem for 32bit systems. Anyway, the best way to deal
with that would be align allocation to 8 bytes.

>> +Poisoning or unpoisoning a byte in the main memory means writing some special
>> +value into the corresponding shadow memory. This value indicates whether the
>> +byte is addressable or not.
>> +
> 


