Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaAPX26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:28:58 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:50077 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaAPX2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:28:54 -0500
MIME-Version: 1.0
In-Reply-To: <52D7EC74.7030401@samsung.com>
References: <1389708830-5841-1-git-send-email-akinobu.mita@gmail.com>
	<1389708830-5841-4-git-send-email-akinobu.mita@gmail.com>
	<52D7EC74.7030401@samsung.com>
Date: Fri, 17 Jan 2014 08:28:53 +0900
Message-ID: <CAC5umyhtr+BXN7dWh3A5QZcMKhHshpt9bzRF_Tce12tu4TMntg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] intel-iommu: integrate DMA CMA
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/16 Marek Szyprowski <m.szyprowski@samsung.com>:
>> @@ -3019,17 +3019,31 @@ static void *intel_alloc_coherent(struct device
>> *hwdev, size_t size,
>>                         flags |= GFP_DMA32;
>>         }
>>   -     vaddr = (void *)__get_free_pages(flags, order);
>> -       if (!vaddr)
>> +       if (!(flags & GFP_ATOMIC)) {
>
>
> GFP_ATOMIC is not a flag, so please change the above check to:
>            if (flags & __GFP_WAIT)

Thanks for your review.  I'll fix it in the next version.
