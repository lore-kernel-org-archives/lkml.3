Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3BKPgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:36:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59209 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3BKPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:36:12 -0500
MIME-Version: 1.0
In-Reply-To: <201302111526.37892.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<201302072312.45988.arnd@arndb.de>
	<CAHTX3dK1Buz3Yh8NTrpsB2X6_17EYT5augOsaLy8_OZQHAOUyw@mail.gmail.com>
	<201302111526.37892.arnd@arndb.de>
Date: Mon, 11 Feb 2013 16:36:05 +0100
Message-ID: <CAHTX3dJxevq3v-o1E6SEM-hFQ4aYi-hkgefX5+-hOmtqy6JgWg@mail.gmail.com>
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

2013/2/11 Arnd Bergmann <arnd@arndb.de>:
> On Monday 11 February 2013, Michal Simek wrote:
>>
>> 2013/2/8 Arnd Bergmann <arnd@arndb.de>:
>> > On Thursday 07 February 2013, Michal Simek wrote:
>> >> Subject: "asm-generic: io: Fix ioread16/32be and iowrite16/32be"
>> >
>> > Ok, thanks. If you don't mind, I think this can just go with the other patches
>> > for xsysace that come out of this discussion.
>>
>> I want to move microblaze to use this asm-generic/io.h that's why I
>> prefer to send
>> this with microblaze patch directly to Linus. For me this make more sense that
>> with sending block device driver changes.
>>
>> What do you think?
>
> Sure, please do it that way. My policy for asm-generic patches is that they
> I prefer to have them go through whatever tree needs them, I was just confused
> about which one that would be in this case.
>

I have just found that it won't be so easy as I thought because I have found
that microblaze wrong implementation was done because of others device drivers.
It means that I have to fix all device drivers to support big and
little endian accessors
first before I can switch microblaze to asm-generic/io.h. :-(

BTW: If you want to take this patch though your tree then ok, or it
can go through my
microblaze tree. Both ways should just work.

I will send the patch for uarlite when I finish my testing on
microblaze, ppc and arm.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
