Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbaKTIri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:47:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20903 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaKTIrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:47:37 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-60-546daaa6f93d
Message-id: <546DAA99.5070402@samsung.com>
Date: Thu, 20 Nov 2014 11:47:21 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/3] mm: sl[aou]b: introduce kmem_cache_zalloc_node()
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.10.1411191545210.32057@chino.kir.corp.google.com>
In-reply-to: <alpine.DEB.2.10.1411191545210.32057@chino.kir.corp.google.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xa7rLVuWGGNxZZWgxZ/0aNovr394w
	WlzeNYfN4t6a/6wWbZ//AYklG5ksNm+ayuzA7rFgU6nHplWdbB6bPk1i93h37hy7x4kZv1k8
	nlyZzuTxeZNcAHsUl01Kak5mWWqRvl0CV8ajs7MZC16yVMxdu5u5gfEdcxcjJ4eEgInE7v4j
	bBC2mMSFe+uBbC4OIYGljBIXrnxhhnCamSQmnloG1sEroCWx9tg5JhCbRUBVYt6HtYwgNpuA
	nsS/WdvBJokKREhcWTOHEaJeUOLH5HssILaIgIZE24z/YBuYBc4xSkyZeRVskLCAp8TEyWeh
	VrczStxf84sVJMEp4CPxfONqoAQHUIeexP2LWiBhZgF5ic1r3jJPYBSYhWTHLISqWUiqFjAy
	r2IUTS1NLihOSs810itOzC0uzUvXS87P3cQICfyvOxiXHrM6xCjAwajEw3thVm6IEGtiWXFl
	7iFGCQ5mJRFepSVAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwLFY7M0PNzVFq6ZydLz+rMTQIL
	lJmeld1xWulr2P6wbsWD1Z1fLG/sc5R1FLnlqXD038aSXyadHtN3/How7SKTcIjk0w1Hak/X
	3X82u9igYl+ZJ1fr40D+LonWf24HBc527vijNPfUztN5fBXn2lZo+k8IiSu/+Xaz8KaapyrX
	czbfa9N4tsVRiaU4I9FQi7moOBEAcZHHoFoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 02:46 AM, David Rientjes wrote:
> On Mon, 10 Nov 2014, Andrey Ryabinin wrote:
> 
>> kmem_cache_zalloc_node() allocates zeroed memory for a particular
>> cache from a specified memory node. To be used for struct irq_desc.
>>
> 
> Is there a reason to add this for such a specialized purpose to the slab 
> allocator?  I think it can just be handled for struct irq_desc explicitly.
> 

It could be used not only for irq_desc. Grepping sources gave me 7 possible users.

We already have zeroing variants of kmalloc/kmalloc_node/kmem_cache_alloc,
so why kmem_cache_alloc_node is special?


