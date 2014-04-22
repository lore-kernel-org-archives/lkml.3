Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbaDVRWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:22:50 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39820 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861AbaDVRWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:22:47 -0400
Message-ID: <5356A562.2090403@gmail.com>
Date: Tue, 22 Apr 2014 19:22:42 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: tj@kernel.org, zmxu@marvell.com, jszhang@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, alexandre.belloni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] ARM: berlin: add the AHCI node for the BG2Q
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com> <1398181105-19714-4-git-send-email-antoine.tenart@free-electrons.com> <20140422182802.447c2912@skate>
In-Reply-To: <20140422182802.447c2912@skate>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 06:28 PM, Thomas Petazzoni wrote:
> Dear Antoine Ténart,
> 
> On Tue, 22 Apr 2014 17:38:22 +0200, Antoine Ténart wrote:
>> The BG2Q has an AHCI SATA controller. Add the corresponding node
>> in its device tree.
> 
> I believe the commit log should explain why an apparently unrelated
> generic-regs@ node gets added in this commit.

generic-regs@ is from another patch, please drop it entirely.

Sebastian

>> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
>> index 07452a7483fa..8e58aae73365 100644
>> --- a/arch/arm/boot/dts/berlin2q.dtsi
>> +++ b/arch/arm/boot/dts/berlin2q.dtsi
>> @@ -183,6 +183,18 @@
>>  			};
>>  		};
>>  
>> +		ahci: sata@e90000 {
>> +			compatible = "marvell,berlin-ahci";
>> +			reg = <0xe90000 0x10000>;
>> +			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
>> +			status = "disable";
>> +		};
>> +
>> +		generic-regs@ea0110 {
>> +			compatible = "marvell,berlin-generic-regs", "syscon";
>> +			reg = <0xea0110 0x10>;
>> +		};
>> +
>>  		apb@fc0000 {
>>  			compatible = "simple-bus";
>>  			#address-cells = <1>;
> 
> 
> 

