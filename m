Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3KUPCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:02:15 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34452 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KUPCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:02:14 -0500
MIME-Version: 1.0
In-Reply-To: <528D4A1A.2050100@zytor.com>
References: <1384903939-3371-1-git-send-email-akinobu.mita@gmail.com>
	<528D4A1A.2050100@zytor.com>
Date: Fri, 22 Nov 2013 00:02:14 +0900
Message-ID: <CAC5umyh0Hfx3NgHX11eqskuifhrdYGB8L1nx1u0YUdBGchRTxw@mail.gmail.com>
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

2013/11/21 H. Peter Anvin <hpa@zytor.com>:
> On 11/19/2013 03:32 PM, Akinobu Mita wrote:
>> The DMA Contiguous Memory Allocator support on x86 is disabled when
>> swiotlb config option is enabled.  So DMA CMA is always disabled on
>> x86_64 because swiotlb is always enabled.  This attempts to support
>> for DMA CMA with enabling swiotlb config option.
>
> What is the use case?

I want to use DMA CMA for the feature that requires a single huge chunk
(about 64MB) of host memory.  Please refer 3 of 24 in:
http://www.jedec.org/sites/default/files/T_Fujisawa_MF_2013.pdf
