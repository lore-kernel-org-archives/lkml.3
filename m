Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaCLMRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:17:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56065 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaCLMRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:17:51 -0400
Message-ID: <53205CA1.1090502@ti.com>
Date: Wed, 12 Mar 2014 15:09:53 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Laura Abbott <lauraa@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv4 2/2] arm: Get rid of meminfo
References: <1392761733-32628-1-git-send-email-lauraa@codeaurora.org> <1392761733-32628-3-git-send-email-lauraa@codeaurora.org> <20140312085401.GB21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140312085401.GB21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 03/12/2014 10:54 AM, Russell King - ARM Linux wrote:
> On Tue, Feb 18, 2014 at 02:15:33PM -0800, Laura Abbott wrote:
>> memblock is now fully integrated into the kernel and is the prefered
>> method for tracking memory. Rather than reinvent the wheel with
>> meminfo, migrate to using memblock directly instead of meminfo as
>> an intermediate.
>>
>> Acked-by: Jason Cooper <jason@lakedaemon.net>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Tested-by: Leif Lindholm <leif.lindholm@linaro.org>
>> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
>
> Laura,
>
> This patch causes a bunch of platforms to no longer boot - imx6solo with
> 1GB of RAM boots, imx6q with 2GB of RAM doesn't.  Versatile Express doesn't.
>
> The early printk messages don't reveal anything too interesting:
>
> Booting Linux on physical CPU 0x0
> Linux version 3.14.0-rc6+ (rmk@rmk-PC.arm.linux.org.uk) (gcc version 4.6.4 (GCC) ) #630 SMP Wed Mar 12 01:13:36 GMT 2014
> CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7d
> CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
> Machine model: SolidRun Cubox-i Dual/Quad
> cma: CMA: reserved 64 MiB at 8c000000
> Memory policy: Data cache writealloc
> <hang>
>
> vs.
>
> Booting Linux on physical CPU 0x0
> Linux version 3.14.0-rc6+ (rmk@rmk-PC.arm.linux.org.uk) (gcc version 4.6.4 (GCC) ) #631 SMP Wed Mar 12 01:15:37 GMT 2014
> CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7d
> CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
> Machine model: SolidRun Cubox-i Dual/Quad
> cma: CMA: reserved 64 MiB at 3b800000
> Memory policy: Data cache writealloc
> On node 0 totalpages: 524288
> free_area_init_node: node 0, pgdat c09d0240, node_mem_map ea7d8000
>    Normal zone: 1520 pages used for memmap
>    Normal zone: 0 pages reserved
>    Normal zone: 194560 pages, LIFO batch:31
>    HighMem zone: 2576 pages used for memmap
>    HighMem zone: 329728 pages, LIFO batch:31
> ...
>
> The only obvious difference is the address of that CMA reservation,
> CMA shouldn't make a difference here - but I suspect that other
> allocations which need to be in lowmem probably aren't.
>

Could it be possible to enable memblock debug by adding "memblock=debug" 
in cmdline?

Regards,
-grygorii


