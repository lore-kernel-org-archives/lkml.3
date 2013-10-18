Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3JRPFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:05:16 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:34217 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3JRPFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:05:14 -0400
MIME-Version: 1.0
In-Reply-To: <00000141c7d66282-aa92b1f2-2a69-424b-9498-8e5367304d32-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1381913052-23875-14-git-send-email-iamjoonsoo.kim@lge.com>
	<00000141c7d66282-aa92b1f2-2a69-424b-9498-8e5367304d32-000000@email.amazonses.com>
Date: Sat, 19 Oct 2013 00:05:12 +0900
Message-ID: <CAAmzW4PsEfGR8TMDiP4LTX7Oj3nr+F4Pxo2DyOEV4ab1pPmwkw@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] slab: use struct page for slab management
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/18 Christoph Lameter <cl@linux.com>:
> On Wed, 16 Oct 2013, Joonsoo Kim wrote:
>
>> -                                      * see PAGE_MAPPING_ANON below.
>> -                                      */
>> +     union {
>> +             struct address_space *mapping;  /* If low bit clear, points to
>> +                                              * inode address_space, or NULL.
>> +                                              * If page mapped as anonymous
>> +                                              * memory, low bit is set, and
>> +                                              * it points to anon_vma object:
>> +                                              * see PAGE_MAPPING_ANON below.
>> +                                              */
>> +             void *s_mem;                    /* slab first object */
>> +     };
>
> The overloading of mapping has caused problems in the past since slab
> pages are (or are they no longer?) used for DMA to disk. At that point the
> I/O subsystem may be expecting a mapping in the page struct if this field
> is not NULL.

I search the history of struct page and find that the SLUB use mapping field
in past (2007 year). At that time, you inserted VM_BUG_ON(PageSlab(page))
('b5fab14') into page_mapping() function to find remaining use. Recently,
I never hear that this is triggered and 6 years have passed since inserting
VM_BUG_ON(), so I guess there is no problem to use it.
If this argument is reasonable, please give me an ACK :)

Thanks.
