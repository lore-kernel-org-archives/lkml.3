Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3FQPyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:54:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:5781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3FQPyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:54:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,882,1363158000"; 
   d="scan'208";a="318305852"
Message-ID: <51BF3170.6090802@intel.com>
Date: Mon, 17 Jun 2013 08:55:28 -0700
From: Dave Jiang <dave.jiang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Jubin Mehta <jubin.mehta@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jon Mason <jon.mason@intel.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
References: <20130613172408.GA5561@intel.com> <CAHp75Ved4kJ6vZPvCcNcZxJgCJKUb-ZCrCNXFJ84DzK095iDPA@mail.gmail.com>
In-Reply-To: <CAHp75Ved4kJ6vZPvCcNcZxJgCJKUb-ZCrCNXFJ84DzK095iDPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 01:59 AM, Andy Shevchenko wrote:
> On Thu, Jun 13, 2013 at 8:24 PM, Jubin Mehta <jubin.mehta@intel.com> wrote:
>> +++ b/drivers/dma/dmatest.c
>> +/*
>> + * Capability Mask Bits.The bits in the cap_mask denote the masking of
>> + * the hardware capabilities of the dma channel.
>> + *
>> + * DMA_CAP_MEMCPY:  Bit 0 for enabling DMA_MEMCPY capability
>> + * DMA_CAP_XOR:     Bit 1 for enabling DMA_XOR capabilit
>> + * DMA_CAP_PQ:      Bit 2 for enabling DMA_PQ capability
>> + * DMA_CAP_ALL:     Enable all the capabilities of the channel
>> + */
>> +#define DMA_CAP_MEMCPY         (1 << 0)
>> +#define DMA_CAP_XOR            (1 << 1)
>> +#define DMA_CAP_PQ             (1 << 2)
> Can we reuse DMA_MEMCPY and so on from enum dma_transaction_type?

The issue is that the originals are enum types. We can't pass bitmap 
type (dma_cap_mask_t) through sysfs. So to use those enums for what we 
want to do it would have to be someting like:
(1 << DMA_MEMCPY)

And also in that case for user scripts you have bits that are here and 
there for the bitmask instead of something simple and sequential.

-- 

Dave Jiang
Application Engineer, Storage Divsion
Intel Corp.
dave.jiang@intel.com

