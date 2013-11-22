Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3KVM10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:27:26 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:65012 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab3KVM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:27:25 -0500
MIME-Version: 1.0
In-Reply-To: <528E4CBA.8000808@zytor.com>
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
	<528D4A1A.2050100@zytor.com>
	<CAC5umyh0Hfx3NgHX11eqskuifhrdYGB8L1nx1u0YUdBGchRTxw@mail.gmail.com>
	<528E4CBA.8000808@zytor.com>
Date: Fri, 22 Nov 2013 21:27:24 +0900
Message-ID: <CAC5umygUgSjUMFECDXAjmSPzpfUZ6=jRhZWhd5hTT2-eO6Oh6Q@mail.gmail.com>
Subject: Re: [PATCH] x86: enable DMA CMA with swiotlb
From: Akinobu Mita <akinobu.mita@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/22 H. Peter Anvin <hpa@zytor.com>:
> On 11/21/2013 07:02 AM, Akinobu Mita wrote:
>>
>> I want to use DMA CMA for the feature that requires a single huge chunk
>> (about 64MB) of host memory.
>
> That is tautological.  "I want to use the Contiguous Memory Allocator to
> allocate contiguous memory."
>
>> Please refer 3 of 24 in:
>> http://www.jedec.org/sites/default/files/T_Fujisawa_MF_2013.pdf
>
> But yes, it makes sense that a device using host memory would not be
> able to leverage swiotlb, because the software simply has no clue what
> the DMA transactions are.  In that sense it is fundamentally different
> from a real IOTLB.

I'm currently working for integrating DMA CMA with intel-iommu which
I can test.  Regardless of which dma ops is actually used, I would
like to allocate large contiguous memory with dma_alloc_coherent()
and tell the base address to the device.

We can use mem= or crashkernel= to reserve host memory, but it is
complicated and unables to work with real IOMMU.
