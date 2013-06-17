Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab3FQPeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:34:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:46108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab3FQPeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:34:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="354950727"
Date: Mon, 17 Jun 2013 08:34:05 -0700
From: Jon Mason <jon.mason@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jubin Mehta <jubin.mehta@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
Message-ID: <20130617153404.GA21232@jonmason-lab>
References: <20130613172408.GA5561@intel.com>
 <CAHp75Ved4kJ6vZPvCcNcZxJgCJKUb-ZCrCNXFJ84DzK095iDPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Ved4kJ6vZPvCcNcZxJgCJKUb-ZCrCNXFJ84DzK095iDPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:59:00AM +0300, Andy Shevchenko wrote:
> On Thu, Jun 13, 2013 at 8:24 PM, Jubin Mehta <jubin.mehta@intel.com> wrote:
> > The current dmatest module tests all the hardware capabilities (MEMCPY, XOR
> > and PQ) supported by a particular DMA channel and these tests are performed
> > concurrently by default. This patch allows the user to enable or disable the
> > test performed for any particular capability. The mask bits for enabling the
> > tests are set using the debugfs.
> 
> This approach I like better.
> Dan, Vinod, what is your opinion?

I withdraw my path in favor of this one.

Thanks,
Jon

> I have couple of comments below.
> 
> > +++ b/Documentation/dmatest.txt
> 
> > +Method to enable the capabilities:
> > +
> > +PATH = /sys/kernel/debug/dmatest/cap_mask
> > +(DEFAULT) echo 0x07 > $PATH     // Set Bits 0,1,2 for MEMCPY, XOR and PQ
> > +          echo 0x01 > $PATH     // Set bit 0 to enable MEMCPY
> > +          echo 0x02 > $PATH     // Set bit 1 to enable XOR
> > +          echo 0x04 > $PATH     // Set bit 2 to enable PQ
> 
> What if we make examples  followed by # and comments?
> And move (DEFAULT) to the commentary.
> 
> > +++ b/drivers/dma/dmatest.c
> 
> > +/*
> > + * Capability Mask Bits.The bits in the cap_mask denote the masking of
> > + * the hardware capabilities of the dma channel.
> > + *
> > + * DMA_CAP_MEMCPY:  Bit 0 for enabling DMA_MEMCPY capability
> > + * DMA_CAP_XOR:     Bit 1 for enabling DMA_XOR capabilit
> > + * DMA_CAP_PQ:      Bit 2 for enabling DMA_PQ capability
> > + * DMA_CAP_ALL:     Enable all the capabilities of the channel
> > + */
> > +#define DMA_CAP_MEMCPY         (1 << 0)
> > +#define DMA_CAP_XOR            (1 << 1)
> > +#define DMA_CAP_PQ             (1 << 2)
> 
> Can we reuse DMA_MEMCPY and so on from enum dma_transaction_type?
> 
> --
> With Best Regards,
> Andy Shevchenko
