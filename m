Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbaFTFqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:46:09 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39626 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667AbaFTFqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:46:06 -0400
Message-ID: <53A3CA96.9040708@linaro.org>
Date: Fri, 20 Jun 2014 13:45:58 +0800
From: zhangfei <zhangfei.gao@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "haifeng.yan@linaro.org" <haifeng.yan@linaro.org>,
        "jchxue@gmail.com" <jchxue@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH 1/2] Documentation: Document Hisilicon hix5hd2 sata PHY
References: <1402991881-27676-1-git-send-email-zhangfei.gao@linaro.org> <1402991881-27676-2-git-send-email-zhangfei.gao@linaro.org> <20140617171357.GH8930@leverpostej>
In-Reply-To: <20140617171357.GH8930@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mark

On 06/18/2014 01:13 AM, Mark Rutland wrote:
> On Tue, Jun 17, 2014 at 08:58:00AM +0100, Zhangfei Gao wrote:
>> From: Jiancheng Xue <xuejiancheng@huawei.com>
>>
>> Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.
>>
>> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>> ---
>>   .../devicetree/bindings/phy/hix5hd2-sata-phy.txt   |   26 ++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
>>
>> diff --git a/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt b/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
>> new file mode 100644
>> index 0000000..ed15123
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
>> @@ -0,0 +1,26 @@
>> +Hisilicon hix5hd2 SATA PHY
>> +-----------------------
>> +
>> +Required properties:
>> +- compatible: should be "hisilicon,hix5hd2-sata-phy"
>> +- reg: offset and length of the PHY registers
>> +- #phy-cells: must be 0
>> +Refer to phy/phy-bindings.txt for the generic PHY binding properties
>> +
>> +Optional Properties:
>> +- hisilicon,peri-syscon: phandle of syscon used to control peripheral.
>
> "peri" is a rather strange contraction of "peripheral".
Will use hisilicon,peripheral-syscon instead, just thought it is too long.
>
>> +- hisilicon,power-reg: offset and bit number of the sata power supply register.
>> +  Only effective when hisilicon,peri-syscon is supplied.
>
> This is the offset within the system controller? It would be good to
> state that.
Change to
- hisilicon,power-reg: offset and bit number within peripheral-syscon,
         register of controlling sata power supply.

>
>> +- hisilicon,reg-init: one of more sets of 4 cells.  The first cell
>> +  is the register offset address, the second cell is the start bit in register,
>> +  the third cell means the bit width, and the fourth cell is the value to set.
>
> Which registers is this meant to be initialising?
>
> Why does this need to be in the DT? How much is this expected to vary?

Double checked with hardware guy, the registers required to be set are 
same in different board, the value maybe different.
Will move to phy-hix5hd2-sata.c directly and remove hisilicon,reg-init.

Thanks for the suggestions.

