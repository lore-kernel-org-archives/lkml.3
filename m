Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaGJTss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:48:48 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56842 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaGJTsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:48:46 -0400
MIME-Version: 1.0
In-Reply-To: <53BEB77A.6020003@intel.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
	<1404905415-9046-2-git-send-email-a.ryabinin@samsung.com>
	<53BDA568.5030607@intel.com>
	<53BE8333.6060404@samsung.com>
	<53BEB77A.6020003@intel.com>
Date: Thu, 10 Jul 2014 23:48:45 +0400
Message-ID: <CAPAsAGwYZ9AVUoOMipZEe8jdmJfd=aULR+yoVH5FqzW1Qa75AQ@mail.gmail.com>
Subject: Re: [RFC/PATCH RESEND -next 01/21] Add kernel address sanitizer infrastructure.
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-10 19:55 GMT+04:00 Dave Hansen <dave.hansen@intel.com>:
> On 07/10/2014 05:12 AM, Andrey Ryabinin wrote:
>> On 07/10/14 00:26, Dave Hansen wrote:
>>> On 07/09/2014 04:29 AM, Andrey Ryabinin wrote:
>>>> Address sanitizer dedicates 1/8 of the low memory to the shadow memory and uses direct
>>>> mapping with a scale and offset to translate a memory address to its corresponding
>>>> shadow address.
>>>>
>>>> Here is function to translate address to corresponding shadow address:
>>>>
>>>>      unsigned long kasan_mem_to_shadow(unsigned long addr)
>>>>      {
>>>>                 return ((addr - PAGE_OFFSET) >> KASAN_SHADOW_SCALE_SHIFT)
>>>>                              + kasan_shadow_start;
>>>>      }
>>>
>>> How does this interact with vmalloc() addresses or those from a kmap()?
>>>
>> It's used only for lowmem:
>>
>> static inline bool addr_is_in_mem(unsigned long addr)
>> {
>>       return likely(addr >= PAGE_OFFSET && addr < (unsigned long)high_memory);
>> }
>
> That's fine, and definitely covers the common cases.  Could you make
> sure to call this out explicitly?  Also, there's nothing to _keep_ this
> approach working for things out of the direct map, right?  It would just
> be a matter of updating the shadow memory to have entries for the other
> virtual address ranges.

Why do you want shadow for things out of the direct map?
If you want to catch use-after-free in vmalloc than DEBUG_PAGEALLOC
will be enough.
If you want catch out-of-bounds in vmalloc you don't need anything,
because vmalloc
allocates guarding hole in the end.
Or do you want something else?

>
> addr_is_in_mem() is a pretty bad name for what it's doing. :)
>
> I'd probably call it something like kasan_tracks_vaddr().
>
Agree

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



-- 
Best regards,
Andrey Ryabinin
