Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaAKSb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:31:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52379 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAKSbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:31:25 -0500
Message-ID: <52D18DE4.2020008@infradead.org>
Date: Sat, 11 Jan 2014 10:31:00 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>, Mike Frysinger <vapier@gentoo.org>
CC: uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org
Subject: Re: blackfin + dmaengine: conflicting define/enum "DMA_COMPLETE"
References: <52D188DA.6020904@pengutronix.de>
In-Reply-To: <52D188DA.6020904@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2014 10:09 AM, Marc Kleine-Budde wrote:
> Hello,
> 
> in current linux-next (and net-next) the compilation of the CAN
> drivers[1] with ARCH=blackfin fails with:
> 
>>   CC [M]  drivers/net/can/c_can/c_can.o
>> In file included from linux/include/linux/netdevice.h:38:0,
>>                  from linux/drivers/net/can/c_can/c_can.c:32:
>> linux/include/linux/dmaengine.h:55:2: error: expected identifier before numeric constant
>> linux/include/linux/dmaengine.h: In function 'dma_async_is_complete':
>> linux/include/linux/dmaengine.h:1023:9: error: 'DMA_IN_PROGRESS' undeclared (first use in this function)
>> linux/include/linux/dmaengine.h:1023:9: note: each undeclared identifier is reported only once for each function it appears in
> 
> There are two locations where DMA_COMPLETE is defined:
> 
>> arch/blackfin/mach-bf548/include/mach/defBF547.h:602:#define              DMA_COMPLETE  0x8        /* DMA Complete */
>> arch/blackfin/mach-bf548/include/mach/defBF544.h:622:#define              DMA_COMPLETE  0x8        /* DMA Complete */
> 
> and
> 
>> include/linux/dmaengine.h-enum dma_status {
>> include/linux/dmaengine.h:      DMA_COMPLETE,
>> include/linux/dmaengine.h-      DMA_IN_PROGRESS,
>> include/linux/dmaengine.h-      DMA_PAUSED,
>> include/linux/dmaengine.h-      DMA_ERROR,
>> include/linux/dmaengine.h-};
> 
> What's the appropriate fix for the problem?

arch/blackfin/mach-bf548/ needs a less generic name for its macro.

> Marc
> 
> [1] Yes, c_can isn't a blackfin driver, but it's the first one in my
>     compile tests and it fails.
> 


-- 
~Randy
