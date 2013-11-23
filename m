Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab3KWN7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 08:59:05 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:63576 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab3KWN7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 08:59:01 -0500
MIME-Version: 1.0
In-Reply-To: <528F71F8.4070902@zytor.com>
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
	<528D4A1A.2050100@zytor.com>
	<CAC5umyh0Hfx3NgHX11eqskuifhrdYGB8L1nx1u0YUdBGchRTxw@mail.gmail.com>
	<528E4CBA.8000808@zytor.com>
	<CAC5umygUgSjUMFECDXAjmSPzpfUZ6=jRhZWhd5hTT2-eO6Oh6Q@mail.gmail.com>
	<528F71F8.4070902@zytor.com>
Date: Sat, 23 Nov 2013 22:59:01 +0900
Message-ID: <CAC5umyiV2F1LoSaHBf6BENpeBSgW_zZDW_8jNOQkDM_zxEpGHA@mail.gmail.com>
Subject: Re: [PATCH] x86: enable DMA CMA with swiotlb
From: Akinobu Mita <akinobu.mita@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/23 H. Peter Anvin <hpa@zytor.com>:
> On 11/22/2013 04:27 AM, Akinobu Mita wrote:
>>
>> I'm currently working for integrating DMA CMA with intel-iommu which
>> I can test.  Regardless of which dma ops is actually used, I would
>> like to allocate large contiguous memory with dma_alloc_coherent()
>> and tell the base address to the device.
>>
>> We can use mem= or crashkernel= to reserve host memory, but it is
>> complicated and unables to work with real IOMMU.
>>
>
> If you have a real iotlb, why would you need contiguous memory?

Because allocating large memory by dma_alloc_coherent() with intel-iommu
fails.  intel_alloc_coherent() allocates memory by alloc_pages() and
then maps it by __intel_map_single().

What I'm trying change wit inte-iommu is adding the same scheme done
by dma_generic_alloc_coherent(), i.e. trying to allocate memory by
dma_alloc_from_contiguous() and alloc_pages() is used as a fallback.
