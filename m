Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbbATLCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:02:12 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:29009 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbbATLBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:01:52 -0500
Message-ID: <54BE351D.1080300@imgtec.com>
Date: Tue, 20 Jan 2015 07:59:41 -0300
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?IlBldGVyIFBhbiDmvZjmoIsgKHBldGVycGFuZG9uZyki?= 
	<peterpandong@micron.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?IlFpIFdhbmcg546L6LW3IChxaXdhbmcpIg==?= 
	<qiwang@micron.com>,
        =?UTF-8?B?IkZyYW5rIExpdSDliJjnvqQgKGZyYW5rbGl1KSI=?= 
	<frankliu@micron.com>,
        =?UTF-8?B?Ik1lbGFuaWUgWmhhbmcg5byg54eVIChtZWxhbmll?=
	 =?UTF-8?B?emhhbmcpIg==?= <melaniezhang@micron.com>
Subject: Re: [PATCH 3/3] mtd: spi-nand: add devicetree binding
References: <87F60714EC601C4C83DFF1D2E3D390A04AB425@NTXXIAMBX02.xacn.micron.com> <54ADF66F.7090400@imgtec.com> <87F60714EC601C4C83DFF1D2E3D390A04AB4EA@NTXXIAMBX02.xacn.micron.com> <54AE9E54.2010506@imgtec.com> <87F60714EC601C4C83DFF1D2E3D390A04AC98F@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <87F60714EC601C4C83DFF1D2E3D390A04AC98F@NTXXIAMBX02.xacn.micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.100.200.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/11/2015 10:57 PM, Peter Pan 潘栋 (peterpandong) wrote:
>> On 01/08/2015 02:04 AM, Peter Pan 潘栋 (peterpandong) wrote:
>>>>> This commit adds the devicetree binding document that specifies the
>>>>> spi nand devices support.
>>>>>
>>>>> Signed-off-by: Peter Pan <peterpandong@micron.com>
>>>>> ---
>>>>>  Documentation/devicetree/bindings/mtd/spi-nand.txt | 22
>>>> ++++++++++++++++++++++
>>>>>  1 file changed, 22 insertions(+)
>>>>>  create mode 100644 Documentation/devicetree/bindings/mtd/spi-
>>>> nand.txt
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/mtd/spi-nand.txt
>>>> b/Documentation/devicetree/bindings/mtd/spi-nand.txt
>>>>> new file mode 100644
>>>>> index 0000000..9dd3efd
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/mtd/spi-nand.txt
>>>>> @@ -0,0 +1,22 @@
>>>>> +* NAND driver for MT29F, GD5F and similar SPI NAND flash chips
>>>>> +
>>>>> +Required properties:
>>>>> +- #address-cells, #size-cells : Must be present if the device has
>>>> sub-nodes
>>>>> +  representing partitions.
>>>>> +- compatible : Should be the manufacturer and the name of the chip.
>>>> Bear in mind
>>>>>
>>>>
>>>> Unless I'm mistaken, we don't need the chip ID here, as SPI NAND
>> allows
>>>> to autodetect the device. Any reason why we can't just use a generic
>>>> compatible "spi-nand" here?
>>>> --
>>>> Ezequiel
>>>
>>> In fact, I don't know how to autodetect the SPI NAND device. Micron
>> device and
>>> Gigadevice device have different read ID functions. The Chip ID here
>> is used to
>>> determine which function to use.
>>>
>>
>> Isn't the difference between the Read ID very minor? One of the vendor
>> needs a 2-byte ID read, and the other one needs a 3-byte ID read.
>>
>> So you can just try with 2-byte, and if that fails (no vendor ID is
>> found on the first byte), you can try with the 3-byte command.
>>
>> It's not the most elegant solution, but it's not super awful either.
>> --
>> Ezequiel
> 
> I agree with your idea about try different ways to read ID. It is a better way
> to detect the chip if it can work properly.
> 
> The difference between the Read ID is that some chips need to send a dummy byte
> or address after opcode then read 2 byte, some chips needn't send any data after
> opcode but read 3 byte.
> 
> I'm concerned maybe chip will get into unknown or vendor specified state if we
> send the wrong sequence.
> 

Have you seen this happpening? Or this a potential/future problem?

For the latter, we can always fix it when the issue appears.
-- 
Ezequiel
