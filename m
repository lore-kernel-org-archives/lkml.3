Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3C1Hmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:42:54 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:62966 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab3C1Hmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:42:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130327152723.723cd65e884413df405abe2d@linux-foundation.org>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
	<1363776767-2635-3-git-send-email-p.zabel@pengutronix.de>
	<20130327152723.723cd65e884413df405abe2d@linux-foundation.org>
Date: Thu, 28 Mar 2013 08:42:52 +0100
Message-ID: <CAHTX3dLT5AePkC77bTMQxre1aQL6-uxj2XBFTHeUZLVyZdN58Q@mail.gmail.com>
Subject: Re: [PATCH v9 RESEND 2/4] misc: Generic on-chip SRAM allocation driver
From: Michal Simek <monstr@monstr.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

2013/3/27 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 20 Mar 2013 11:52:45 +0100 Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
>> This driver requests and remaps a memory region as configured in the
>> device tree. It serves memory from this region via the genalloc API.
>> It optionally enables the SRAM clock.
>>
>> Other drivers can retrieve the genalloc pool from a phandle pointing
>> to this drivers' device node in the device tree.
>>
>> The allocation granularity is hard-coded to 32 bytes for now,
>> to make the SRAM driver useful for the 6502 remoteproc driver.
>> There is overhead for bigger SRAMs, where only a much coarser
>> allocation granularity is needed: At 32 bytes minimum allocation
>> size, a 256 KiB SRAM needs a 1 KiB bitmap to track allocations.
>>
>>  Documentation/devicetree/bindings/misc/sram.txt |   16 +++
>>  drivers/misc/Kconfig                            |    9 ++
>>  drivers/misc/Makefile                           |    1 +
>>  drivers/misc/sram.c                             |  121 +++++++++++++++++++++++
>
> drivers/misc/sram.c is a pretty generic-sounding thing.  Is it really
> Linux's One True SRAM driver?  How many different sorts of sram devices
> do we expect this can be used with?  If I don't use DT?

I want to use it for xilinx microblaze BRAM and zynq OCM and BRAMS connected
to buses on Microblaze, PPC and ARM zynq.

I have there just one small problem with OCM because we have a suspend code
which is copied to it and execute from it and current implementation
has no handling for it because all memory you get is not executable.

I am not sure how to handle this properly. Currently I am calling
gen_pool_alloc which returns virtual address, then gen_pool_virt_to_phys to
get physical address and then __arm_ioremap with MT_DEVICE .
This works but it looks ugly. And also this is not generic solution
because it doesn't work on Microblaze.

Is there any other nice way how to ask for executable memory?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
