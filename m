Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaGQMbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:31:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63981 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbaGQMbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:31:51 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-e5-53c7c233f877
Message-id: <53C7C234.4030903@samsung.com>
Date: Thu, 17 Jul 2014 14:31:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        ralf@linux-mips.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, mina86@mina86.com
Cc: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] mips: Add cma support to mips
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com>
In-reply-to: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4FV3jQ8eDDT4es7D4O+kYu8X7ZT2M
	Fs2L17NZTNsobtGx6yuLxabH11gtLu+aw2YxYeokdosFx1tYLS4dWMBkcWmPisXmTVOZLV5+
	PMFi8WPDY1aLv21vmB34PdbMW8Po8fvXJEaPnp1nGD02repk83h37hy7x9GVa5k89s9dw+6x
	eUm9x7o/r5g83u+7yubxeZOcx4mWL6wBPFFcNimpOZllqUX6dglcGTPnfmAu2MVTMf1IZQPj
	Sc4uRk4OCQETiXP7brJA2GISF+6tZ+ti5OIQEljKKPF/zVRGCOcTo8SpnXvBqngFtCQ61vxi
	72Lk4GARUJXYubAQJMwmYCjR9baLDcQWFYiRONP7mRmiXFDix+R7LCBzRAS+MUocer4fbCiz
	wERGiRdfDrODVAkLmElMW93NCGILCXhJ3P3TwQRicwp4Szz/+A1sMTNQzaOWdcwQtrzE5jVv
	mScwCsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJu687GJceszrE
	KMDBqMTD+4PreLAQa2JZcWXuIUYJDmYlEd5tXUAh3pTEyqrUovz4otKc1OJDjEwcnFINjM4L
	EiUzcjdopiyO2fPxyo2TohtXBJk02W5rNJvo/tNu2XX5B3f2ftp+V3M1n2pWrO67j0YP525L
	cy8tOWH9sVyke7VUrHrqRCYelo7XakvEd0aVvNynHPPdKH3NLet95T7zdNZ6ui1a1fN219GD
	fn4Ja1UdTj+887NNPGURx6L6tb8nrHmbyafEUpyRaKjFXFScCABqtWeemQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-16 17:51, Zubair Lutfullah Kakakhel wrote:
> Here we have 4 patches that add cma support to mips.
>
> Patch 1 adds dma-contiguous.h to asm-generic
> Patch 2 and 3 make arm64 and x86 use dma-contiguous from asm-generic
> Patch 4 adds cma to mips.
>
> I'd like to request ralf to take these set of 4 patches via his tree.
>
> acks from asm-generic, arm64 and x86 welcome.
>
> patches based on linux-next b997a07604562f1a54cc531fe1cf7447f0ed6078

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> Zubair Lutfullah Kakakhel (4):
>    asm-generic: Add dma-contiguous.h
>    arm64: use generic dma-contiguous.h
>    x86: use generic dma-contiguous.h
>    mips: dma: Add cma support
>
>   arch/arm64/include/asm/Kbuild           |  1 +
>   arch/arm64/include/asm/dma-contiguous.h | 28 -------------------------
>   arch/mips/Kconfig                       |  1 +
>   arch/mips/include/asm/Kbuild            |  1 +
>   arch/mips/kernel/setup.c                |  9 ++++++++
>   arch/mips/mm/dma-default.c              | 37 ++++++++++++++++++++++-----------
>   arch/x86/include/asm/Kbuild             |  1 +
>   arch/x86/include/asm/dma-contiguous.h   | 12 -----------
>   include/asm-generic/dma-contiguous.h    |  9 ++++++++
>   9 files changed, 47 insertions(+), 52 deletions(-)
>   delete mode 100644 arch/arm64/include/asm/dma-contiguous.h
>   delete mode 100644 arch/x86/include/asm/dma-contiguous.h
>   create mode 100644 include/asm-generic/dma-contiguous.h

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

