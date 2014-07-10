Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaGJHgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:36:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17189 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaGJHgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:36:41 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-3a-53be42859d95
Message-id: <53BE4141.6060908@samsung.com>
Date: Thu, 10 Jul 2014 11:31:13 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 01/21] Add kernel address sanitizer
 infrastructure.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-2-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.11.1407090924030.1384@gentwo.org>
In-reply-to: <alpine.DEB.2.11.1407090924030.1384@gentwo.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xy7qtTvuCDY61WVv83juT1WLO+jVs
	FsvnzGWymPCwjd1iZXczm8X2Z2+ZLFZ2PmC12PT4GqvFn107mCwu75rDZnFvzX9Wi9uXeS0u
	HVjAZNGy7wKTRdvnf6wW+1aeB7KWbGSyWHzkNrPFu2eTmS02b5rKbPFjw2NWB1GPluYeNo/9
	h4s8ds66y+6xYFOpx6ZVnWwemz5NYvfoenuFyePduXPsHidm/Gbx2Lyk3uPj01ssHu/3XWXz
	OLPgCLvH501yAXxRXDYpqTmZZalF+nYJXBlzXpxhLljIWjFn2X7mBsZ+li5GTg4JAROJ/oMz
	mCFsMYkL99azdTFycQgJLGWUaN7ykx3CaWaSWLK8A6yDV0BL4tHnuawgNouAqsSK3XfButkE
	9CT+zdrOBmKLCkRIHOh7xgpRLyjxY/I9sF4RoPrrM0+DbWAWuMwq0f3iKliRsECURM/zM4wQ
	2zYzSuzrmMYIkuAUsJG4t28j2AZmAR2J/a3T2CBseYnNa94yT2AUmIVkySwkZbOQlC1gZF7F
	KJpamlxQnJSea6hXnJhbXJqXrpecn7uJERLJX3YwLj5mdYhRgINRiYdXo3Z3sBBrYllxZe4h
	RgkOZiUR3m12+4KFeFMSK6tSi/Lji0pzUosPMTJxcEo1MDrJJKQkTeiZ9VF76/GXi7YclDqp
	w5KRLfiMZb7IHH2Zpd8TPO3U7n/UDiyctUsx+tvi9EPrM62WyvTvlnvwZp5bNaeFnyCbULaY
	3HYLsRC3vz+/SZ18+8lA+5nR6qXfbOc0Tvo3/zrbBMFL5zwPn+9d8ubknOWSOzaemXpSh1F6
	/c471m6ZiglKLMUZiYZazEXFiQBcfN25wgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 18:26, Christoph Lameter wrote:
> On Wed, 9 Jul 2014, Andrey Ryabinin wrote:
> 
>> +
>> +Markers of unaccessible bytes could be found in mm/kasan/kasan.h header:
>> +
>> +#define KASAN_FREE_PAGE         0xFF  /* page was freed */
>> +#define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
>> +#define KASAN_SLAB_REDZONE      0xFD  /* Slab page redzone, does not belong to any slub object */
> 
> We call these zones "PADDING". Redzones are associated with an object.
> Padding is there because bytes are left over, unusable or necessary for
> alignment.
> 
Goop point. I will change the name to make it less confusing.
