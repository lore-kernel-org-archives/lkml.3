Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaGQJRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:17:52 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:5635 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbaGQJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:17:50 -0400
Message-ID: <53C794B0.4060504@imgtec.com>
Date: Thu, 17 Jul 2014 10:17:36 +0100
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, Ralf Baechle <ralf@linux-mips.org>,
        <gregkh@linuxfoundation.org>, <m.szyprowski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>
Subject: Re: [PATCH 4/4] mips: dma: Add cma support
References: <1405525892-60383-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1405525892-60383-5-git-send-email-Zubair.Kakakhel@imgtec.com> <xa1t7g3db6mu.fsf@mina86.com>
In-Reply-To: <xa1t7g3db6mu.fsf@mina86.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/07/14 17:39, Michal Nazarewicz wrote:
> On Wed, Jul 16 2014, Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com> wrote:
>> Adds cma support to the mips architecture.
>>
>> cma uses memblock. However, mips uses bootmem.
> 
> Does cma_early_percent_memory work correctly then?
> 

Yes it does. All memblock functions work. And this is before bootmem
is informed.

>> bootmem is informed about any regions reserved by memblock
> 
> Alternatively maybe it would make sense to create a new definition of
> dma_contiguous_reserve_area that uses bootmem and choose it based on
> some CONFIG_CMA_USE_BOOTMEM which would be selected by MIPS.
> 

Telling bootmem takes only 3 lines.

Adding CONFIG_CMA_USE_BOOTMEM would add more functions and maintenance overhead.
And it will basically do the same thing.
Reserve memory. And tell the bootmem allocator.

>> dma api is modified to use cma reserved memory regions when available
>>
>> Tested using cma_test. cma_test is a simple driver that assigns blocks
>> of memory from cma reserved sections.
>>
>> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Thank-you

ZubairLK
