Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946071Ab3BHIYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:24:13 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57262 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790Ab3BHIYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:24:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWEr-uZqc6P1CGNw0P6JG3FGsRKJLB1tLWzuYuBujTzfQ@mail.gmail.com>
References: <1360246728-3490-1-git-send-email-michal.simek@xilinx.com>
	<CAMuHMdWEr-uZqc6P1CGNw0P6JG3FGsRKJLB1tLWzuYuBujTzfQ@mail.gmail.com>
Date: Fri, 8 Feb 2013 09:24:11 +0100
Message-ID: <CAHTX3d+2SpK5pe5d-++j+CrDEF7orDa7zHfQChy21z+Ls2MDJQ@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: io: Fix ioread16/32be and iowrite16/32be
From: Michal Simek <monstr@monstr.eu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/8 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Thu, Feb 7, 2013 at 3:18 PM, Michal Simek <michal.simek@xilinx.com> wrote:
>> Fix ioreadXXbe and iowriteXXbe functions which did
>> additional little endian conversion on native big endian systems.
>> Using be_to_cpu (cpu_to_be) conversions with __raw_read/write
>> functions have resolved it.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> CC: Arnd Bergmann <arnd@arndb.de>
>> CC: Geert Uytterhoeven <geert@linux-m68k.org>
>> CC: Will Deacon <will.deacon@arm.com>
>> CC: linux-arch@vger.kernel.org
>
> I have one question (see below). Apart from that:
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
>> -#define ioread16be(addr)       be16_to_cpu(ioread16(addr))
>> +#define ioread16be(addr)       __be16_to_cpu(__raw_readw(addr))
>
> Why did you change it to the __beX_to_cpu variant with underscores?

The question could be probably different. Why are they even defined?
I have grepped the kernel and all archs use these generic macros

include/linux/byteorder/generic.h:94:#define be32_to_cpu __be32_to_cpu
include/linux/byteorder/generic.h:106:#define be32_to_cpup __be32_to_cpup
include/linux/byteorder/generic.h:118:#define be32_to_cpus __be32_to_cpus

What about to remove them?

Back to you question. I can't remember particular reason for that maybe
just experience that __ versions should be the fastest kernel implementation.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
