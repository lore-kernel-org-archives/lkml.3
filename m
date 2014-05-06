Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaEFUp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:45:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51361 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbaEFUpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:45:24 -0400
Message-ID: <536949B8.3030106@ti.com>
Date: Tue, 6 May 2014 16:44:40 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <CAL_Jsq+nh26NZXx-9Y5FTxWZdVrG7aLTOBhC4j9P8mPPvUu2ag@mail.gmail.com> <536806F4.1090904@ti.com> <7182186.5Q53eQg77F@wuerfel>
In-Reply-To: <7182186.5Q53eQg77F@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 05:40 AM, Arnd Bergmann wrote:
> On Monday 05 May 2014 17:47:32 Santosh Shilimkar wrote:
> 
>> +       dev->coherent_dma_mask = DMA_BIT_MASK(32);
>> +       if (!dev->dma_mask)
>> +               dev->dma_mask = &dev->coherent_dma_mask;
>> +
>> +       /*
>> +        * if dma-ranges property doesn't exist - just return else
>> +        * setup the dma offset
>> +        */
>> +       ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
>> +       if (ret < 0) {
>> +               dev_dbg(dev, "no dma range information to setup\n");
>> +               return;
>> +       }
>> +
>> +       /* DMA ranges found. Calculate and set dma_pfn_offset */
>> +       dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
>> +       dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
>> +}
> 
> I think there should at least be a comment about why we are computing
> the correct DMA mask here and then ignore that and just use DMA_BIT_MASK(32)
> instead. I understand that Russell and Rob prefer it that way and I'm not
> going to argue, but I find it counterintuitive and I think it deserves
> an explanation in the source code for anybody who is trying to figure
> out how things fit together.
> 
In this patch, the dma_mask related code is just moved. We are not calculating
dma_mask either. I was looking for the history of how DMA_BIT_MASK(32)
landed up but couldn't trace it down apart from the fact that the code was
carried from powerPC. May be Rob knows.

How about below comment ? I didn't delibratly added point about bus
intercepting drivers dma_set_*mask() call etc.

/*
 * Set default dma-mask to 32 bit. Drivers are expected to setup
 * the correct supported dma_mask.
 */  
+       dev->coherent_dma_mask = DMA_BIT_MASK(32);
+       if (!dev->dma_mask)
+               dev->dma_mask = &dev->coherent_dma_mask;

Regards,
Santosh
