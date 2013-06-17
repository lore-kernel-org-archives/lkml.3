Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3FQI7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:59:02 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46322 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3FQI7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130613172408.GA5561@intel.com>
References: <20130613172408.GA5561@intel.com>
Date: Mon, 17 Jun 2013 11:59:00 +0300
Message-ID: <CAHp75Ved4kJ6vZPvCcNcZxJgCJKUb-ZCrCNXFJ84DzK095iDPA@mail.gmail.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jubin Mehta <jubin.mehta@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 8:24 PM, Jubin Mehta <jubin.mehta@intel.com> wrote:
> The current dmatest module tests all the hardware capabilities (MEMCPY, XOR
> and PQ) supported by a particular DMA channel and these tests are performed
> concurrently by default. This patch allows the user to enable or disable the
> test performed for any particular capability. The mask bits for enabling the
> tests are set using the debugfs.

This approach I like better.
Dan, Vinod, what is your opinion?

I have couple of comments below.

> +++ b/Documentation/dmatest.txt

> +Method to enable the capabilities:
> +
> +PATH = /sys/kernel/debug/dmatest/cap_mask
> +(DEFAULT) echo 0x07 > $PATH     // Set Bits 0,1,2 for MEMCPY, XOR and PQ
> +          echo 0x01 > $PATH     // Set bit 0 to enable MEMCPY
> +          echo 0x02 > $PATH     // Set bit 1 to enable XOR
> +          echo 0x04 > $PATH     // Set bit 2 to enable PQ

What if we make examples  followed by # and comments?
And move (DEFAULT) to the commentary.

> +++ b/drivers/dma/dmatest.c

> +/*
> + * Capability Mask Bits.The bits in the cap_mask denote the masking of
> + * the hardware capabilities of the dma channel.
> + *
> + * DMA_CAP_MEMCPY:  Bit 0 for enabling DMA_MEMCPY capability
> + * DMA_CAP_XOR:     Bit 1 for enabling DMA_XOR capabilit
> + * DMA_CAP_PQ:      Bit 2 for enabling DMA_PQ capability
> + * DMA_CAP_ALL:     Enable all the capabilities of the channel
> + */
> +#define DMA_CAP_MEMCPY         (1 << 0)
> +#define DMA_CAP_XOR            (1 << 1)
> +#define DMA_CAP_PQ             (1 << 2)

Can we reuse DMA_MEMCPY and so on from enum dma_transaction_type?

--
With Best Regards,
Andy Shevchenko
