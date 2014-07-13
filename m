Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaGMKj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 06:39:28 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:46652 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaGMKjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 06:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <53C08876.10209@zytor.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
	<53C08876.10209@zytor.com>
Date: Sun, 13 Jul 2014 14:39:21 +0400
Message-ID: <CAPAsAGwb2sLmu0o_o-pFP5pXhMs-1sZSJbA3ji=W+JPOZRepgg@mail.gmail.com>
Subject: Re: [RFC/PATCH -next 00/21] Address sanitizer for kernel (kasan) -
 dynamic memory error detector.
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
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

2014-07-12 4:59 GMT+04:00 H. Peter Anvin <hpa@zytor.com>:
> On 07/09/2014 04:00 AM, Andrey Ryabinin wrote:
>>
>> Address sanitizer dedicates 1/8 of the low memory to the shadow memory and uses direct
>> mapping with a scale and offset to translate a memory address to its corresponding
>> shadow address.
>>
>> Here is function to translate address to corresponding shadow address:
>>
>>      unsigned long kasan_mem_to_shadow(unsigned long addr)
>>      {
>>               return ((addr) >> KASAN_SHADOW_SCALE_SHIFT)
>>                            + kasan_shadow_start - (PAGE_OFFSET >> KASAN_SHADOW_SCALE_SHIFT);
>>      }
>>
>> where KASAN_SHADOW_SCALE_SHIFT = 3.
>>
>
> How does that work when memory is sparsely populated?
>

Sparsemem configurations currently may not work with kasan.
I suppose I will have to move shadow area to vmalloc address space and
make it (shadow) sparse too if needed.

>         -hpa
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



-- 
Best regards,
Andrey Ryabinin
