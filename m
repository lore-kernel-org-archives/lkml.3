Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaIZHcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:32:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13831 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaIZHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:32:12 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-7b-542516785955
Message-id: <542514DD.5080402@samsung.com>
Date: Fri, 26 Sep 2014 11:25:17 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.0
MIME-version: 1.0
To: Dmitry Vyukov <dvyukov@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 09/13] mm: slub: add kernel address sanitizer support
 for slub allocator
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-10-git-send-email-a.ryabinin@samsung.com>
 <CACT4Y+a0DMk8vyCcesrsKt7rXVDD2LZsfnGemJAgeRiVbMxxxw@mail.gmail.com>
In-reply-to: <CACT4Y+a0DMk8vyCcesrsKt7rXVDD2LZsfnGemJAgeRiVbMxxxw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t/xK7oVYqohBs8ealr83juT1WLO+jVs
	FkeufWe3uP7tDaPFp5cPGC22XG9isnj+8CG7xYSHbewW0zaKW6zsbmaz2P7sLZPFys4HrBaX
	d81hs7i35j+rRdvnf0BiyUYmi8VHbjNbvHs2mdni6qqD7BY/NjxmdRDxmL/zI6PHzll32T0W
	bCr1WLznJZPHplWdbB6bPk1i9+h6e4XJ48SM3yweT65MZ/L4+PQWi8f7fVfZPD5vkvM40fKF
	NYA3issmJTUnsyy1SN8ugSvjzqJWtoJLOhV73m5gaWC8q9DFyMkhIWAise71EzYIW0ziwr31
	QDYXh5DAUkaJGZevMkI4zUwSex/MYgKp4hXQkvj1oJEFxGYRUJV4e+I6WDebgJ7Ev1nbwWxR
	gQiJKfuXskLUC0r8mHwPrF5EQE2i8XUP2AZmgW2sEsdu/2QGSQgLJEo09rSxQ2xrZ5Jo2NkL
	1sEpECzx5fFOsM3MAuoSk+YtYoaw5SU2r3nLPIFRYBaSJbOQlM1CUraAkXkVo2hqaXJBcVJ6
	rpFecWJucWleul5yfu4mRkjkft3BuPSY1SFGAQ5GJR7eG+tUQoRYE8uKK3MPMUpwMCuJ8CqL
	qoYI8aYkVlalFuXHF5XmpBYfYmTi4JRqYJw389aFyG/p1z9vvWroXDR/81yGd8fTbEIn80v5
	R54xnvnjr5CNsk+GsmGA/rLCqVO2PApLSN989VtFlTl7mNPSBU8u7WB4/3r2FJ7AjW/YVr17
	LOP+hLcg+PzGjbNcm24JnuqZcv98n9pdc4vln4XXGd/T371Q+mblw9M/sjVOxu+vOMc7NSFN
	iaU4I9FQi7moOBEA0/nyMLoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 08:48 AM, Dmitry Vyukov wrote:
> On Wed, Sep 24, 2014 at 5:44 AM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
>> --- a/lib/Kconfig.kasan
>> +++ b/lib/Kconfig.kasan
>> @@ -6,6 +6,7 @@ if HAVE_ARCH_KASAN
>>  config KASAN
>>         bool "AddressSanitizer: runtime memory debugger"
>>         depends on !MEMORY_HOTPLUG
>> +       depends on SLUB_DEBUG
> 
> 
> What does SLUB_DEBUG do? I think that generally we don't want any
> other *heavy* debug checks to be required for kasan.
> 

SLUB_DEBUG enables support for different debugging features.
It doesn't enables this debugging features by default, it only allows
you to switch them on/off in runtime.
Generally SLUB_DEBUG option is enabled in most kernels. SLUB_DEBUG disabled
only with intention to get minimal kernel.

Without SLUB_DEBUG there will be no redzones, no user tracking info (allocation/free stacktraces).
KASAN won't be so usefull without SLUB_DEBUG.


[...]

>> --- a/mm/kasan/kasan.c
>> +++ b/mm/kasan/kasan.c
>> @@ -30,6 +30,7 @@
>>  #include <linux/kasan.h>
>>
>>  #include "kasan.h"
>> +#include "../slab.h"
>>
>>  /*
>>   * Poisons the shadow memory for 'size' bytes starting from 'addr'.
>> @@ -265,6 +266,102 @@ void kasan_free_pages(struct page *page, unsigned int order)
>>                                 KASAN_FREE_PAGE);
>>  }
>>
>> +void kasan_free_slab_pages(struct page *page, int order)
> 
> Doesn't this callback followed by actually freeing the pages, and so
> kasan_free_pages callback that will poison the range? If so, I would
> prefer to not double poison.
> 

Yes, this could be removed.

> 
>> +{
>> +       kasan_poison_shadow(page_address(page),
>> +                       PAGE_SIZE << order, KASAN_SLAB_FREE);
>> +}
>> +
>> +void kasan_mark_slab_padding(struct kmem_cache *s, void *object)
>> +{
>> +       unsigned long object_end = (unsigned long)object + s->size;
>> +       unsigned long padding_end = round_up(object_end, PAGE_SIZE);
>> +       unsigned long padding_start = round_up(object_end,
>> +                                       KASAN_SHADOW_SCALE_SIZE);
>> +       size_t size = padding_end - padding_start;
>> +
>> +       if (size)
>> +               kasan_poison_shadow((void *)padding_start,
>> +                               size, KASAN_SLAB_PADDING);
>> +}
>> +
>> +void kasan_slab_alloc(struct kmem_cache *cache, void *object)
>> +{
>> +       kasan_kmalloc(cache, object, cache->object_size);
>> +}
>> +
>> +void kasan_slab_free(struct kmem_cache *cache, void *object)
>> +{
>> +       unsigned long size = cache->size;
>> +       unsigned long rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
>> +
> 
> Add a comment saying that SLAB_DESTROY_BY_RCU objects can be "legally"
> used after free.
> 

Ok.

>> +       if (unlikely(cache->flags & SLAB_DESTROY_BY_RCU))
>> +               return;
>> +
>> +       kasan_poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
>> +}
>> +
>> +void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size)
>> +{
>> +       unsigned long redzone_start;
>> +       unsigned long redzone_end;
>> +
>> +       if (unlikely(object == NULL))
>> +               return;
>> +
>> +       redzone_start = round_up((unsigned long)(object + size),
>> +                               KASAN_SHADOW_SCALE_SIZE);
>> +       redzone_end = (unsigned long)object + cache->size;
>> +
>> +       kasan_unpoison_shadow(object, size);
>> +       kasan_poison_shadow((void *)redzone_start, redzone_end - redzone_start,
>> +               KASAN_KMALLOC_REDZONE);
>> +
>> +}
>> +EXPORT_SYMBOL(kasan_kmalloc);
>> +
>> +void kasan_kmalloc_large(const void *ptr, size_t size)
>> +{
>> +       struct page *page;
>> +       unsigned long redzone_start;
>> +       unsigned long redzone_end;
>> +
>> +       if (unlikely(ptr == NULL))
>> +               return;
>> +
>> +       page = virt_to_page(ptr);
>> +       redzone_start = round_up((unsigned long)(ptr + size),
>> +                               KASAN_SHADOW_SCALE_SIZE);
>> +       redzone_end = (unsigned long)ptr + (PAGE_SIZE << compound_order(page));
> 
> If size == N*PAGE_SIZE - KASAN_SHADOW_SCALE_SIZE - 1, the object does
> not receive any redzone at all. 

If size == N*PAGE_SIZE - KASAN_SHADOW_SCALE_SIZE - 1, there will be redzone
KASAN_SHADOW_SCALE_SIZE + 1 bytes. There will be no readzone if and only if
(size == PAGE_SIZE << compound_order(page))

> Can we pass full memory block size
> from above to fix it? Will compound_order(page) do?
> 

What is full memory block size?
PAGE_SIZE << compound_order(page) is how much was really allocated.


[..]

>>
>>  static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
>> @@ -1416,8 +1426,10 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
>>                 setup_object(s, page, p);
>>                 if (likely(idx < page->objects))
>>                         set_freepointer(s, p, p + s->size);
> 
> Sorry, I don't fully follow this code, so I will just ask some questions.
> Can we have some slab padding after last object in this case as well?
> 
This case is for not the last object. Padding is the place after the last object.
The last object initialized bellow in else case.

>> -               else
>> +               else {
>>                         set_freepointer(s, p, NULL);
>> +                       kasan_mark_slab_padding(s, p);
> 
> kasan_mark_slab_padding poisons only up to end of the page. Can there
> be multiple pages that we need to poison?
> 
Yep, that's a good catch.

Thanks.
