Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab3BGOTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:19:38 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57878 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426Ab3BGOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:19:36 -0500
MIME-Version: 1.0
In-Reply-To: <201302070833.15443.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<51135F43.4030209@monstr.eu>
	<CAMuHMdWWfSaO-BSMjiGpScrrtZmsAHnpSDDOMAAsFOsWEJuSow@mail.gmail.com>
	<201302070833.15443.arnd@arndb.de>
Date: Thu, 7 Feb 2013 15:19:35 +0100
Message-ID: <CAHTX3dLuAhpy-Yk10scRKrfRrbh+ZZs-hgFLAFn0Vj562V0Cew@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 07 February 2013, Geert Uytterhoeven wrote:
>>
>> On Thu, Feb 7, 2013 at 9:01 AM, Michal Simek <monstr@monstr.eu> wrote:
>> > ok. Can you please confirm with me that the same problem is also for
>> > iowrite32be
>> > ioread16be and ioread32be?
>> >
>> > This description seems to me correct for BE and LE.
>> > #define ioread16be(addr)       __be16_to_cpu(__raw_readw(addr))
>> > #define ioread32be(addr)       __be32_to_cpu(__raw_readl(addr))
>> >
>> > #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)
>> > #define iowrite32be(v, addr)   __raw_writel(__cpu_to_be32(v), addr)
>> >
>> > What do you think?
>>
>> Looks fine to me. Arnd, Ben?
>
> Yes, that would be better. Can you prepare a patch?

Done:
Subject: "asm-generic: io: Fix ioread16/32be and iowrite16/32be"

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
