Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab3ETViI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:38:08 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:50354 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3ETViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:38:06 -0400
Message-ID: <519A97B8.1090503@gmail.com>
Date: Mon, 20 May 2013 23:38:00 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Simon Baatz <gmbnomis@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, David Miller <davem@davemloft.net>,
        Florian Fainelli <florian@openwrt.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] ARM: kirkwood: add gigabit ethernet and mvmdio
 device tree nodes
References: <1365071235-11611-1-git-send-email-florian@openwrt.org> <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com> <1367854420-8006-7-git-send-email-sebastian.hesselbarth@gmail.com> <20130520212708.GA26519@schnuecks.de>
In-Reply-To: <20130520212708.GA26519@schnuecks.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 11:27 PM, Simon Baatz wrote:
> Hi Sebastian,
>
> On Mon, May 06, 2013 at 05:33:39PM +0200, Sebastian Hesselbarth wrote:
>> This patch adds mv643xx_eth and mvmdio device tree nodes for DT enabled
>> Kirkwood boards. Phy nodes are also added with reg property set on a
>> per-board basis.
> ...
>> diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
>> index fada7e6..c01a273 100644
>> --- a/arch/arm/boot/dts/kirkwood.dtsi
>> +++ b/arch/arm/boot/dts/kirkwood.dtsi
>> @@ -202,5 +202,57 @@
>>   			clocks =<&gate_clk 4>;
>>   			status = "disabled";
>>   		};
>> +
>> +		mdio: mdio-bus@72004 {
>> +			compatible = "marvell,orion-mdio";
>> +			reg =<0x72004 0x84>;
>> +			interrupts =<11>;
>
> Shouldn't this be 46?

Yes, mdio is using GbE0Err interrupt and that is 14 on IRQ HIGH CAUSE.
I was misled by 11 on IRQ LOW CAUSE.

Sebastian
