Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaADUbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 15:31:33 -0500
Received: from blu0-omc1-s24.blu0.hotmail.com ([65.55.116.35]:34513 "EHLO
	blu0-omc1-s24.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367AbaADUbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 15:31:32 -0500
X-TMN: [n7V5YzojJg1Y6MJ6r5DmWggQp6tD8oH6]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP1018039B0747722C9B5B22E97B50@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Mikulas Patocka <mpatocka@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401041451350.21108@file01.intranet.prod.int.rdu2.redhat.com>
Subject: Re: [PATCH] fix crash when using XFS on loopback
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com> <BLU0-SMTP390C5C965F9A4FB18F1EBE97B50@phx.gbl> <alpine.LRH.2.02.1401041451350.21108@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sat, 4 Jan 2014 15:31:13 -0500
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@iki.fi>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 04 Jan 2014 20:31:30.0329 (UTC) FILETIME=[F3417090:01CF098B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4-Jan-14, at 2:55 PM, Mikulas Patocka wrote:

> On Sat, 4 Jan 2014, John David Anglin wrote:
>
>> On 4-Jan-14, at 12:45 PM, Mikulas Patocka wrote:
>>
>>> * flush_dcache_page asks for the list of userspace mappings,  
>>> however that
>>> page->mapping field is reused by the slab subsystem for a different
>>> purpose. This causes the crash.
>>
>> I'd noticed the other day that the parisc implementation of
>> flush_dcache_page()
>> should return if "!mapping || mapping != page->mapping" is true.   
>> This would
>> have avoided crash.
>>
>> Dave
>
> I think no.
>
> page_mapping returns NULL if the page has only anonymous mapping and  
> it is
> not placed in the swap cache. In this case, you need to flush the  
> kernel
> cache.


The suggestion is to add the "mapping != page->mapping" to the current  
NULL check.
It occurs after the kernel cache flush.

It doesn't seem right to flush the vma mappings associated with swap  
address space
and that appears to be happening with current code.

Dave
--
John David Anglin	dave.anglin@bell.net



