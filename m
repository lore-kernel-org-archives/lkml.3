Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3BEMjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:39:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61677 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3BEMjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:39:01 -0500
MIME-Version: 1.0
In-Reply-To: <1360066756.4529.6.camel@pasglop>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<1781360.cmQWHCW5SC@wuerfel>
	<CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	<201302041724.47331.arnd@arndb.de>
	<1360031367.14701.47.camel@pasglop>
	<CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
	<1360066756.4529.6.camel@pasglop>
Date: Tue, 5 Feb 2013 13:38:58 +0100
Message-ID: <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/5 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> On Tue, 2013-02-05 at 11:54 +0100, Michal Simek wrote:
>>
>> xilinx ppc is big endian
>> xilinx arm is little endian
>> xilinx microblaze is little endian and big endian
>
> You are talking about the core, why should the xsysace block driver be
> synthesized with the same endianness as the core ? That's not terribly
> useful, especially since reverse load/stores on ppc are essentially
> free...

It is done by hardware guys and I can do nothing with it.

>> It is just sharing the same IP across all platforms. Which is better
>> than create new devices and new device drivers for it. It means that
>> all of them are register compatible but require access with native
>> platform endianness as I listed above.
>
> Every attempt at doing "native platform endianness" has always been a
> misguided attempt turning into a trainwreck (see OHCI USB).
>
> Just pick one endian for the device and stick to it.

It is reality and I can't change it. Arnd mentioned it earlier that USB


>> It is not a problem to create runtime wrapper and even detect endian
>> directly in the driver
>> but the point if this is the proper design.
>> Also ioread32 and ioread32be shouldn't be used on ARM because there
>> are missing memory barriers.
>
> Then fix them, they shouldn't be, it's a bug, it will break many other
> drivers. They should be fully equivalent to readl.

I want to be sure about this. I have parsed this again with closer look and
seems to me that ioread32 is equal to readl and iowrite32 to writel.
Arnd: Am I right?

Thanks,
Michal






-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
