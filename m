Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3A3MKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:10:52 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:50751 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3A3MKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:10:49 -0500
Message-ID: <51090DB5.7050203@synopsys.com>
Date: Wed, 30 Jan 2013 17:40:29 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <benh@kernel.crashing.org>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201301291627.34913.arnd.bergmann@linaro.org> <5108FDEA.20206@synopsys.com> <CAHTX3dKXgwfEHjyG4jnkOb2dKn2RG-Uofp50o5hDq=f9TiyWDA@mail.gmail.com>
In-Reply-To: <CAHTX3dKXgwfEHjyG4jnkOb2dKn2RG-Uofp50o5hDq=f9TiyWDA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 04:43 PM, Michal Simek wrote:
> 2013/1/30 Alexey Brodkin <Alexey.Brodkin@synopsys.com>:
>> On 01/29/2013 08:27 PM, Arnd Bergmann wrote:
>>> On Tuesday 29 January 2013, Alexey Brodkin wrote:
>>>> in(out)_8/in(out)_be16/in(out)_le16 are very powerpc/microblaze
>>>> specific. To enable use of Xilinx System ACE driver build for other
>>>> architectures (for example it's possible to use it on Xilinx ml-509
>>>> board with ARC700 in FPGA) we need to use generic implementation of
>>>> accessors.
>>>>
>>>> Current implementation was successfully built with Sourcery G++ Lite
>>>> 2011.03-39 for Power EABI (ppc44x_defconfig).
>>>>
>>>> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
>>>
>>> Is this driver used on powerpc64 as well, or just on microblaze
>>> and/or 32 bit powerpc?
>>>
>>> On 64 bit powerpc, ioread involves extra overhead because it
>>> goes through the PCI error handling implementation, so we should
>>> keep using in_le() there.
>>>
>>>         Arnd
>>>
>> Personally I have no idea about usage of the named device on powerpc64.
>> Wondering if anybody may comment on this?
>>
>> My only intention was to make the driver portable.
>> Do you think if there's another generic alternative for originally used
>> accessors?
>>
>> For example will it be better with "readb/readw/writeb/writew"?
> This driver is used on ppc32, microblaze little and big endian
> and probably could be used on arm le.

We intend to use it on ARC architecture, for the Xilinx ML509 boards we use. ARC
port doesn't yet have the special I/O accessors this driver uses. While I can
easily add them to ARC port, it would be better to make this driver portable. This
either means replacing the special I/O accessors the driver uses with what we have
now (if possible on arches) or else provide a default implementation for these
special accessors in asm-generic. I'm up for either one although first approach is
preferable as it avoid adding another set to the zoo of accessors we have right now.

But just adding the accessors to ARC port is a band-aid IMHO.

> Not sure if we can find out proper IO function which we should use.

Is it because of the intricacies of I/O on the arches it uses or because we don't
have well defined semantics of what read/ioread friends should do - or yet
something else.

> btw: I will have to support all these combinations for uartlite, xilinx_spi,
> gpio and others xilinx IPs.

Which further justifies solving this is a proper way anyways.

Thx,
-Vineet
