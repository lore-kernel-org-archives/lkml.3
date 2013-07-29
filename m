Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3G2OK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:10:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48390 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3G2OKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:10:25 -0400
Message-ID: <51F677CB.4090100@gmail.com>
Date: Mon, 29 Jul 2013 16:10:19 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maen Suleiman <maen@marvell.com>, Lior Amsalem <alior@marvell.com>
Subject: Re: [PATCH 1/4] ARM: dove: add cpu device tree node
References: <1375100946-28521-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375100946-28521-2-git-send-email-sebastian.hesselbarth@gmail.com> <51F6630D.5010603@arm.com>
In-Reply-To: <51F6630D.5010603@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 02:41 PM, Sudeep KarkadaNagesha wrote:
> On 29/07/13 13:29, Sebastian Hesselbarth wrote:
>> This adds a node for the Marvell Sheeva PJ4A CPU found on Dove SoCs.
>> While at it, also move the l2-cache node out of internal registers and
>> consistently name different nodes.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   arch/arm/boot/dts/dove.dtsi |   52 ++++++++++++++++++++++++++-----------------
>>   1 file changed, 32 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
>> index 8d5be1e8..09d9710 100644
>> --- a/arch/arm/boot/dts/dove.dtsi
>> +++ b/arch/arm/boot/dts/dove.dtsi
>> @@ -10,6 +10,23 @@
>>   		gpio2 = &gpio2;
>>   	};
>>
>> +	cpus {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		cpu0: cpu@0 {
>> +			compatible = "marvell,pj4a", "marvell,sheeva-v7";
>> +			device_type = "cpu";
>> +			next-level-cache = <&l2>;
>> +			reg = <0>;
>> +		};
>> +	};
>> +
>> +	l2: l2-cache {
>> +		compatible = "marvell,tauros2-cache";
>> +		marvell,tauros2-cache-features = <0>;
>> +	};
> Hi Sebastian,
>
> This is not entirely related to the patch but thought of checking with
> you. I was trying to get info on L2 cache controller on Marvell SoCs,
> mainly structure or way/set size. Is that something we can get
> dynamically ? Some specification I referred said its integrated and some
> said its separate(not unified). Basically I need information around
> various L2 cache implementations(Tauros2/Feroceon) from Marvell.
>
> Any pointers or contacts to get this information will be helpful.

Sudeep,

I added Maen and Lior on Cc. Unfortunately, public Marvell SoC
datasheets only refer some closed Marvell datasheets when it comes
to CPU(s) used. Maybe they can help out.

Sebastian

