Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaAPXen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:34:43 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:55064 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaAPXej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:34:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140115200934.GC5201@phenom.dumpdata.com>
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
	<1389708830-5841-2-git-send-email-akinobu.mita@gmail.com>
	<20140115200934.GC5201@phenom.dumpdata.com>
Date: Fri, 17 Jan 2014 08:34:38 +0900
Message-ID: <CAC5umygcr0a_BfDJ9tB1EDry4UEwThG7WvkA8Dn27zO9RQab8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] x86: make dma_alloc_coherent() return zeroed
 memory if CMA is enabled
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/16 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> On Tue, Jan 14, 2014 at 11:13:46PM +0900, Akinobu Mita wrote:
>> Calling dma_alloc_coherent() with __GFP_ZERO must return zeroed memory.
>>
>> But when the contiguous memory allocator (CMA) is enabled on x86 and
>> the memory region is allocated by dma_alloc_from_contiguous(), it
>> doesn't return zeroed memory.  Because dma_generic_alloc_coherent()
>
> So why not fix it there to return zeroed out memory?

I thought it looked nicer than this patch as we can remove memset
from all caller of dma_alloc_from_contiguous().  But if I look at
the caller on arm, we can't simply remove the memset because
__dma_clear_buffer() is used there for ensuring cache flushing and
it is used in many places.

Of course we can do redundant memset in dma_alloc_from_contiguous(),
but now I think this patch is less impact for fixing this problem.
