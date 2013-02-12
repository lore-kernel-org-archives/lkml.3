Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab3BLMOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:14:18 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39645 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941Ab3BLMOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:14:16 -0500
MIME-Version: 1.0
In-Reply-To: <201302121126.10288.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<201302111608.29304.arnd@arndb.de>
	<CAHTX3dJUduUj1a5_xCfjVc0y3J4-zUKZrBpQTvSj=SVVz=gvsg@mail.gmail.com>
	<201302121126.10288.arnd@arndb.de>
Date: Tue, 12 Feb 2013 13:14:15 +0100
Message-ID: <CAHTX3dKn7iwbHyOnpJ4XiNbK766oqrJW06kH7XrAW2TJtOhehA@mail.gmail.com>
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

2013/2/12 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday 12 February 2013, Michal Simek wrote:
>> > In particular, ARM can run both big- and little-endian even though
>> > big-endian is rarely used, so you need to know the endianess for
>> > the device you are talking to rather than assume that it knows
>> > what the CPU does at the time.
>>
>> For high performance IPs using accessors functions is still problematic
>> because there will be performance regression it means that
>> from my point of view there still should be any option to "setup"
>> proper endians for the driver and it can't be setup at run-time.
>
> I did not mean you have to use a run-time detection here, although
> that is often the easiest solution. If you know the endianess of
> a device for a specific architecture or platform, it is totally
> fine to pick that endianess at compile-time and use e.g. the
> readl_relaxed() accessors on ARM to give you the lowest access
> latency.

ok but still there should be well defined how to do it. Let's say
generic Kconfig option.
Or maybe there is also third option to modified code to use proper writes.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
