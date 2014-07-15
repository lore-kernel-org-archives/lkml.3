Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaGOOiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:38:05 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38543 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaGOOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:37:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-64-53c53cc30993
Content-transfer-encoding: 8BIT
Message-id: <53C53B77.3080000@samsung.com>
Date: Tue, 15 Jul 2014 18:32:23 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: Christoph Lameter <cl@gentwo.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [RFC/PATCH -next 00/21] Address sanitizer for kernel (kasan) -
 dynamic memory error detector.
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
 <53C08876.10209@zytor.com>
 <CAPAsAGwb2sLmu0o_o-pFP5pXhMs-1sZSJbA3ji=W+JPOZRepgg@mail.gmail.com>
 <alpine.DEB.2.11.1407141012520.25405@gentwo.org>
In-reply-to: <alpine.DEB.2.11.1407141012520.25405@gentwo.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t/xq7qHbY4GGxxssLH4vXcmq8Wc9WvY
	LJbPmctkMeFhG7vFtI3iFiu7m9kstj97y2SxsvMBq8Wmx9dYLf7s2sFkcXnXHDaLe2v+s1rc
	vsxrcenAAiaLln0XmCzaPv9jtdi38jyQtWQjk8XxrVuYLRYfuc1s8e7ZZGaLzZumMlv82PCY
	1UHco6W5h81j/+Eij52z7rJ7LNhU6rFpVSebx6ZPk9g9ut5eYfJ4d+4cu8eJGb9ZPDYvqff4
	+PQWi8f7fVfZPM4sOMLu8XmTnMeJli+sAfxRXDYpqTmZZalF+nYJXBmLZz9kKXjPXvG5ZzNT
	A+MKti5GDg4JAROJ4xOsuhg5gUwxiQv31rOB2EICSxklJjX6gNi8AoISPybfYwEpZxaQlzhy
	KRskzCygLjFp3iLmLkYuoPJmJonGq1fYIeq1JJ6fvMcIYrMIqEq03rwJZrMJ6En8m7UdbL6o
	QITEgb5nrCC2iIC/xPfDVxlBBjELfGWVON53khkkISyQI3Fy3haoDXcYJXYunssCkuAUsJU4
	8GUq8wRGgVlIDpyFcOAsJAcuYGRexSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRES3V92MC4+
	ZnWIUYCDUYmHt0LscLAQa2JZcWXuIUYJDmYlEV5Jk6PBQrwpiZVVqUX58UWlOanFhxiZODil
	GhgrnXjWHPlis9so55mC1eKMageX3Vt/cVyZZpnDw3A0U1I9oZ1jqmNz1BInzorms+cvrn5x
	cd+6T/8U/XTtdIzDFlzY1721YP8jf7PGrS1S0mZMs4NPa5kwKU2Se11+UUEzoSSoVVzz/rI1
	h/tOTfM73vRuYtSL+yv5HGr5FN4IdfwW9DS5aafEUpyRaKjFXFScCAC+VcjTzAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/14 19:13, Christoph Lameter wrote:
> On Sun, 13 Jul 2014, Andrey Ryabinin wrote:
> 
>>> How does that work when memory is sparsely populated?
>>>
>>
>> Sparsemem configurations currently may not work with kasan.
>> I suppose I will have to move shadow area to vmalloc address space and
>> make it (shadow) sparse too if needed.
> 
> Well it seems to work with sparsemem / vmemmap? So non vmmemmapped configs
> of sparsemem only. vmemmmap can also handle holes in memory.
> 
> 

Not sure. This sparsemem/vmemmap thing is kinda new to me, so I need to dig some more
to understand how it iтteracts with kasan.

As far as I understand the main problem with sparsemem & kasan is shadow allocation:

	unsigned long lowmem_size = (unsigned long)high_memory - PAGE_OFFSET;
	shadow_size = lowmem_size >> KASAN_SHADOW_SCALE_SHIFT;

	shadow_phys_start = memblock_alloc(shadow_size, PAGE_SIZE);

If we don't have one big enough physically contiguous block for shadow it will fail.

