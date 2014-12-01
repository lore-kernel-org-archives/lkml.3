Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaLANHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:07:52 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52625 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaLANHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:07:51 -0500
Message-ID: <547C6837.5070309@gmail.com>
Date: Mon, 01 Dec 2014 21:08:07 +0800
From: Zhou Wang <wangzhou.bry@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mtd: hisilicon: add device tree binding documentation
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com> <1415105221-7732-3-git-send-email-wangzhou.bry@gmail.com> <20141130085654.GE3608@norris-Latitude-E6410>
In-Reply-To: <20141130085654.GE3608@norris-Latitude-E6410>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月30日 16:56, Brian Norris wrote:
> On Tue, Nov 04, 2014 at 08:47:01PM +0800, Zhou Wang wrote:
>> Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
>> ---
>>   .../devicetree/bindings/mtd/hisi504-nand.txt       |   40 ++++++++++++++++++++
>>   1 file changed, 40 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/mtd/hisi504-nand.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mtd/hisi504-nand.txt b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
>> new file mode 100644
>> index 0000000..c8b3988
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
>> @@ -0,0 +1,40 @@
>> +Hisilicon Hip04 Soc NAND controller DT binding
>> +
>> +Required properties:
>> +- compatible:          Should be "hisilicon,504-nfc".
>> +- reg:                 The first contains base physical address and size of
>> +                       NAND controller's registers. The second contains base
>> +                       physical address and size of NAND controller's buffer.
>> +- interrupts:          Interrupt number for nfc.
>> +- nand-bus-width:      See nand.txt.
>> +- nand-ecc-mode:       See nand.txt.
>
> Do you support all modes, or just "hw"? Might be worth noting here.
>

The driver just supports "hw" mode, will modify this.

>> +- hisi,nand-ecc-bits:  ECC bits type support.
>> +                 <0>:  none ecc
>> +                 <1>:  Can correct 1bit per 512byte.
>> +                 <6>:  Can correct 16bits per 1K byte.
>
> You should re-use the nand-ecc-strength and nand-ecc-step-size
> properties here. So you'll support these options:
>
>    nand-ecc-strength=0  nand-ecc-step-size=<don't care>
>    nand-ecc-strength=1  nand-ecc-step-size=512
>    nand-ecc-strength=16 nand-ecc-step-size=1024

Thanks, will modify this!

>
>> +- #address-cells:      partition address, should be set 1.
>> +- #size-cells:         partition size, should be set 1.
>> +
>> +Flash chip may optionally contain additional sub-nodes describing partitions of
>> +the address space. See partition.txt for more detail.
>> +
>> +Example:
>> +
>> +	nand: nand@4020000 {
>> +		compatible = "hisilicon,504-nfc";
>> +		reg = <0x4020000 0x10000>, <0x5000000 0x1000>;
>> +		interrupts = <0 379 4>;
>> +		nand-bus-width = <8>;
>> +		nand-ecc-mode = "hw";
>> +		hisi,nand-ecc-bits = <1>;
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +
>> +		partition@0 {
>> +			label = "nand_text";
>> +			reg = <0x00000000 0x00400000>;
>> +		};
>> +
>> +		...
>> +
>> +	};
>
> Brian
>

Thanks,
Zhou Wang

