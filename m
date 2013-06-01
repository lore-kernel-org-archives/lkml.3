Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3FAV55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 17:57:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39662 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3FAV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 17:57:52 -0400
Message-ID: <51AA6E1F.7080003@infradead.org>
Date: Sat, 01 Jun 2013 14:56:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Emil Goode <emilgoode@gmail.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] usb: musb: use the new %pa format specifier for dma_addr_t
References: <1370109747-18821-1-git-send-email-emilgoode@gmail.com>  <1370111350.2098.1.camel@joe-AO722> <20130601190926.GA5541@debian> <1370118685.2098.7.camel@joe-AO722>
In-Reply-To: <1370118685.2098.7.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/13 13:31, Joe Perches wrote:
> On Sat, 2013-06-01 at 21:09 +0200, Emil Goode wrote:
>> I see, will send a second version.
> 
> Hey Emil.
> 
> I believe you can not use %pa with a dma_addr_t
> because that could be a different size than a
> phy_addr_t.
> 
> (the vsprintf cast and deref is to a phy_addr_t)

Hi Joe,

Thank you for pointing that out.  It's a bit of a shame that this
comment was deleted from include/asm-generic/types.h in commit
3e50594e8e72932ad4cfcb0b3cbdf58fc3bce416:

-/*
- * DMA addresses may be very different from physical addresses
- * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
- * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
- * physical addresses.
- * This default defines dma_addr_t to have the same size as
- * phys_addr_t, which is the most common way.
- * Do not define the dma64_addr_t type, which never really
- * worked.
- */


> The definitions are: (types.h)
> 
> #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> typedef u64 dma_addr_t;
> #else
> typedef u32 dma_addr_t;
> #endif /* dma_addr_t */
> 
> []
> 
> #ifdef CONFIG_PHYS_ADDR_T_64BIT
> typedef u64 phys_addr_t;
> #else
> typedef u32 phys_addr_t;
> #endif
> 
> On Sat, Jun 01, 2013 at 11:29:10AM -0700, Joe Perches wrote:
>> On Sat, 2013-06-01 at 20:02 +0200, Emil Goode wrote:
>>> This patch makes use of the new format specifier %pa that was introduced
>>> by the following commit.
>>>
>>> 7d7992108d02aa92ad4c77e5d9ce14088c942e75
>>> ("lib/vsprintf.c: add %pa format specifier for phys_addr_t types")
>> []
>>> diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
>> []
>>> @@ -1756,12 +1756,11 @@ void musb_host_rx(struct musb *musb, u8 epnum)
>> []
>>> -                   dev_dbg(musb->controller, "RX%d count %d, buffer 0x%llx len %d/%d\n",
>>> +                   dev_dbg(musb->controller, "RX%d count %d, buffer 0x%pa len %d/%d\n",
>>
>> This would emit 0x0x<addr>


-- 
~Randy
