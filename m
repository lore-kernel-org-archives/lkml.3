Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaDYKNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:13:36 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:58360 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaDYKNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <201404221552.00501.arnd@arndb.de>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397845149-3141-1-git-send-email-lftan@altera.com>
	<1397845149-3141-4-git-send-email-lftan@altera.com>
	<201404221552.00501.arnd@arndb.de>
Date: Fri, 25 Apr 2014 18:13:31 +0800
X-Google-Sender-Auth: cnSv5t4lUrPoG1A-Wk7n_3nNVao
Message-ID: <CAFiDJ58__vjDk93crSxGe1us0K7a3kSUwScgk=VaJYy+VqXsWQ@mail.gmail.com>
Subject: Re: [PATCH 14/28] nios2: DMA mapping API
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 9:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 April 2014, Ley Foon Tan wrote:
>
>> +static inline int dma_supported(struct device *dev, u64 mask)
>> +{
>> +     /* we fall back to GFP_DMA when the mask isn't all 1s,
>> +      * so we can't guarantee allocations that must be
>> +      * within a tighter range than GFP_DMA.
>> +      */
>> +     if (mask < 0x00ffffff)
>> +             return 0;
>> +
>> +     return 1;
>> +}
>
>> +void *dma_alloc_coherent(struct device *dev, size_t size,
>> +                         dma_addr_t *dma_handle, gfp_t gfp)
>> +{
>> +     void *ret;
>> +
>> +     /* ignore region specifiers */
>> +     gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
>> +
>> +     /* optimized page clearing */
>> +     gfp |= __GFP_ZERO;
>> +
>> +     if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
>> +             gfp |= GFP_DMA;
>
> What is the significance of ZONE_DMA on this architecture?
>
> Do you actually have DMA masters with a 0x00ffffff mask?
Actually, nios2 doesn't have DMA master with 0x00ffffff mask. I will
change it to return 1, same as some other architectures
implementation.
And the ZONE_DMA stuff will remove as well, it shouldn't have ZONE_DMA
limitation.
