Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab3BLKDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:03:39 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42263 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287Ab3BLKDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:03:36 -0500
MIME-Version: 1.0
In-Reply-To: <1360628726.17442.19.camel@pasglop>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<201302111526.37892.arnd@arndb.de>
	<CAHTX3dJxevq3v-o1E6SEM-hFQ4aYi-hkgefX5+-hOmtqy6JgWg@mail.gmail.com>
	<201302111543.46196.arnd@arndb.de>
	<CAHTX3dJ6pZWyGB=6T22wA_wR-Tqty+4Nywm84g_n4djTv-cT=g@mail.gmail.com>
	<1360628726.17442.19.camel@pasglop>
Date: Tue, 12 Feb 2013 11:03:23 +0100
Message-ID: <CAHTX3dLtFca5TaeWBX-oF6eCQyAa3h-4DKtqYEXS6QuHbDLZCg@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/12 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> On Mon, 2013-02-11 at 16:57 +0100, Michal Simek wrote:
>> But it reminds me that maybe the easiest solution is not to use endian
>> accessors just use two simple macros which should work on all systems.
>>
>> #define <name>_readreg(offset)          ({__raw_readl(offset); rmb(); })
>> #define <name>_writereg(offset, val)    ({wmb(); __raw_writel(val, offset); })
>>
>> which is probably the faster solution which add minimum additional code
>> to driver and can also remove endian detection code.
>
> Except that rmb & wmb might not be the right barriers for IOs ...

Arm is using __iormb in readX macros
#define __iormb()		rmb()
but it is arm specific only that's why I have added there rmb().

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
