Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaCKWV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:21:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46598 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaCKWVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:21:25 -0400
Message-ID: <531F8C3A.1040502@oracle.com>
Date: Tue, 11 Mar 2014 18:20:42 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: mmap_sem lock assertion failure in __mlock_vma_pages_range
References: <531F6689.60307@oracle.com>			<1394568453.2786.28.camel@buesod1.americas.hpqcorp.net>		 <20140311133051.bf5ca716ef189746ebcff431@linux-foundation.org>		 <531F75D1.3060909@oracle.com>	 <1394570844.2786.42.camel@buesod1.americas.hpqcorp.net>	 <531F79F7.5090201@oracle.com> <1394574323.2786.45.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1394574323.2786.45.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 05:45 PM, Davidlohr Bueso wrote:
> On Tue, 2014-03-11 at 17:02 -0400, Sasha Levin wrote:
>> >On 03/11/2014 04:47 PM, Davidlohr Bueso wrote:
>>>> > >>Bingo! With the above patch:
>>>>> > >> >
>>>>> > >> >[  243.565794] kernel BUG at mm/vmacache.c:76!
>>>>> > >> >[  243.566720] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>>>> > >> >[  243.568048] Dumping ftrace buffer:
>>>>> > >> >[  243.568740]    (ftrace buffer empty)
>>>>> > >> >[  243.569481] Modules linked in:
>>>>> > >> >[  243.570203] CPU: 10 PID: 10073 Comm: trinity-c332 Tainted: G        W    3.14.0-rc5-next-20140307-sasha-00010-g1f812cb-dirty #143
>>> > >and this is also part of the DEBUG_PAGEALLOC + trinity combo! I suspect
>>> > >the root cause it the same as Fengguang's report.
>> >
>> >The BUG still happens without DEBUG_PAGEALLOC.
> Any idea what trinity itself is doing?
>
> Could you add the following, I just want to make sure the bug isn't
> being caused by an overflow:

Not hitting that WARN.


Thanks,
Sasha
