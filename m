Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3BEKp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:45:59 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:35548 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3BEKp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:45:56 -0500
MIME-Version: 1.0
In-Reply-To: <201302041724.47331.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<1781360.cmQWHCW5SC@wuerfel>
	<CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	<201302041724.47331.arnd@arndb.de>
Date: Tue, 5 Feb 2013 11:45:55 +0100
Message-ID: <CAHTX3dKwo4VyNgXDf1B3aSHk10uy-QDzskvA0qUC2Jurs34TAA@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        benh@kernel.crashing.org, alan@lxorguk.ukuu.org.uk,
        geert@linux-m68k.org, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/4 Arnd Bergmann <arnd@arndb.de>:
> On Monday 04 February 2013, Michal Simek wrote:
>> >
>> > and select the CONFIG_FOO_BIG_ENDIAN and CONFIG_FOO_LITTLE_ENDIAN
>> > symbols in Kconfig based on the system you are building for.
>>
>> Using CONFIG_FOO_BIG/LITTLE is not good because it is just another
>> Kconfig option.
>> You can easily detect it at runtime and for dedicated hw with fixed
>> endians you can just
>> handle it in the driver and don't care about global setting.
>
> The configuration option should not be visible, so it's
> not something a user would have to worry about. It's just
> sometimes nicer to express the configuration of the platform
> in terms of Kconfig syntax than it is in C code if you have
> complex platform dependencies.
>
>> > This of course gets further complicated if you require different
>> > accessors per architecture, like ARM wanting readl or ioread32
>> > and PowerPC wanting in_le32 for a little-endian SoC component.
>>
>> FYI: I have got two responses on linux-arch from Alan
>> "Set the pointers up and pass them as data with your platform device, that
>> way the function definitions are buried in your platform code where they
>> depend."
>>
>> and Geert:
>> "Or embed a struct io_ops * in struct device, to be set up by the bus driver?
>>
>> Wasn't David Hinds working on something like this in the context of PCMCIA
>> a few decades ago?"
>>
>> Based on their suggestions one way can be to pass it through void *platform_data
>> which is probably not the best and then which make more sense to me is to extend
>> struct dev_archdata archdata to add there native read/write functions.
>>
>> What do you think?
>
> I worry a little about code size if we have a lot of drivers that go
> from one instruction to an indirect function call for each readl/writel.
> Using platform_data ss also something that does not work too well with
> device tree based platform configuration, which tries hard to leave
> all run-time configuration inside of the driver.

As you have seen from the list of architectures all of them uses device tree.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
