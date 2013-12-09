Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448Ab3LIU00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:26:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45281 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3LIU0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:26:23 -0500
Message-ID: <52A6275F.4040007@oracle.com>
Date: Mon, 09 Dec 2013 15:26:07 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
CC: joern@logfs.org, mgorman@suse.de, Michel Lespinasse <walken@google.com>,
        riel@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: kernel BUG in munlock_vma_pages_range
References: <52A3D0C3.1080504@oracle.com> <52A58E8A.3050401@suse.cz> <52A5F83F.4000207@oracle.com> <52A5F9EE.4010605@suse.cz>
In-Reply-To: <52A5F9EE.4010605@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 12:12 PM, Vlastimil Babka wrote:
> On 12/09/2013 06:05 PM, Sasha Levin wrote:
>> On 12/09/2013 04:34 AM, Vlastimil Babka wrote:
>>> Hello, I will look at it, thanks.
>>> Do you have specific reproduction instructions?
>>
>> Not really, the fuzzer hit it once and I've been unable to trigger it again. Looking at
>> the piece of code involved it might have had something to do with hugetlbfs, so I'll crank
>> up testing on that part.
>
> Thanks. Do you have trinity log and the .config file? I'm currently unable to even boot linux-next
> with my config/setup due to a GPF.
> Looking at code I wouldn't expect that it could encounter a tail page, without first encountering a
> head page and skipping the whole huge page. At least in THP case, as TLB pages should be split when
> a vma is split. As for hugetlbfs, it should be skipped for mlock/munlock operations completely. One
> of these assumptions is probably failing here...

If it helps, I've added a dump_page() in case we hit a tail page there and got:

[  980.172299] page:ffffea003e5e8040 count:0 mapcount:1 mapping:          (null) index:0
x0
[  980.173412] page flags: 0x2fffff80008000(tail)

I can also add anything else in there to get other debug output if you think of something else useful.


Thanks,
Sasha

