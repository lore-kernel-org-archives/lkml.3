Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3BFQVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:21:44 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33554 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3BFQVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:21:38 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
	<51111133.7000105@synopsys.com>
	<7613336.0C5oRATusX@wuerfel>
	<CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
Date: Wed, 6 Feb 2013 17:21:37 +0100
Message-ID: <CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/6 Grant Likely <grant.likely@secretlab.ca>:
> On Tue, Feb 5, 2013 at 3:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 05 February 2013 18:03:31 Alexey Brodkin wrote:
>>> The Xilinx System ACE Compact Flash chip is a true little-endian device
>>> and the PLB is a big-endian bus. Therefore the XPS System ACE Interface
>>> Controller will do a bit-swap in each byte when connecting the PLB data
>>> bus to the System ACE data bus as shown in Table 2.
>>>
>>> Note however, that the XPS System ACE Interface Controller does not
>>> perform the byte swapping necessary to interface to a little-endian
>>> device when configured to use 16-bit mode. Therefore, the software
>>> drivers provided for this core will perform the necessary byte-swapping
>>> to correctly interface to the Xilinx System ACE Compact Flash chip as
>>> shown in Table 3.
>>
>> Ok. In this case, I would recommend making the default for this driver
>> little-endian, and adding a quirk for broken hardware bridges like the
>> one you cited to have a mixed-endian mode if configured so at compile
>> time.
>>
>> It seems that on all normal platforms, this device should behave as
>> little-endian, while the Xilinx bridge can be either big-endian
>> or little-endian, depending on whether it is used in 8-bit or 16-bit
>> mode, so if we are using this, it cannot be known at compile time.
>
> The driver already handles this. It has three sets of accessors;
> 8-bit, 16-bit LE and 16-bit BE *and* when doing 16-bit it figures out
> on its own which set to use at runtime. There is nothing controversial
> here. The only problem is that the driver is currently using in_/out_
> IO accessors instead of ioread/iowrite variants.

I have looked at the patches from more practical side and I have tested it on
microblaze big endian in 16bit mode and I have found that sysace driver
stop to work.
After that I have looked at ioread/iowrite microblaze implementation
and implementation of that functions is wrong.
I have fixed it but looking at using asm-generic/io.h for microblaze.

I will do more tests and let you know.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
