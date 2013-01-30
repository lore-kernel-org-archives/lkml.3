Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3A3LNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:13:50 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33987 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3A3LNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:13:47 -0500
MIME-Version: 1.0
In-Reply-To: <5108FDEA.20206@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<201301291627.34913.arnd.bergmann@linaro.org>
	<5108FDEA.20206@synopsys.com>
Date: Wed, 30 Jan 2013 12:13:46 +0100
Message-ID: <CAHTX3dKXgwfEHjyG4jnkOb2dKn2RG-Uofp50o5hDq=f9TiyWDA@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Michal Simek <monstr@monstr.eu>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, Vineet.Gupta1@synopsys.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/30 Alexey Brodkin <Alexey.Brodkin@synopsys.com>:
> On 01/29/2013 08:27 PM, Arnd Bergmann wrote:
>>
>> On Tuesday 29 January 2013, Alexey Brodkin wrote:
>>>
>>> in(out)_8/in(out)_be16/in(out)_le16 are very powerpc/microblaze
>>> specific. To enable use of Xilinx System ACE driver build for other
>>> architectures (for example it's possible to use it on Xilinx ml-509
>>> board with ARC700 in FPGA) we need to use generic implementation of
>>> accessors.
>>>
>>> Current implementation was successfully built with Sourcery G++ Lite
>>> 2011.03-39 for Power EABI (ppc44x_defconfig).
>>>
>>> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
>>
>>
>> Is this driver used on powerpc64 as well, or just on microblaze
>> and/or 32 bit powerpc?
>>
>> On 64 bit powerpc, ioread involves extra overhead because it
>> goes through the PCI error handling implementation, so we should
>> keep using in_le() there.
>>
>>         Arnd
>>
>
> Personally I have no idea about usage of the named device on powerpc64.
> Wondering if anybody may comment on this?
>
> My only intention was to make the driver portable.
> Do you think if there's another generic alternative for originally used
> accessors?
>
> For example will it be better with "readb/readw/writeb/writew"?

This driver is used on ppc32, microblaze little and big endian
and probably could be used on arm le.

Not sure if we can find out proper IO function which we should use.

btw: I will have to support all these combinations for uartlite, xilinx_spi,
gpio and others xilinx IPs.

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
