Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaDRLpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:45:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32833 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751197AbaDRLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:45:16 -0400
Message-ID: <53511044.9070601@free-electrons.com>
Date: Fri, 18 Apr 2014 13:45:08 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 5/8] ARM: mvebu: Add Device Tree description of xHCI hosts
 on Armada 38x
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com> <1397816563-9000-6-git-send-email-gregory.clement@free-electrons.com> <53510B28.1070709@gmail.com>
In-Reply-To: <53510B28.1070709@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,
On 18/04/2014 13:23, Sebastian Hesselbarth wrote:
> On 04/18/2014 12:22 PM, Gregory CLEMENT wrote:
>> The Marvell Armada 38x SoCs contain two xHCI host. This commit adds
>> the Device Tree description of those interfaces at the SoC level, and
>> also enables the two USB3 ports on the Armada 385 DB platform and one
>> USB3 port on the Armada 385 RD platforms.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>  arch/arm/boot/dts/armada-385-db.dts |  8 ++++++++
>>  arch/arm/boot/dts/armada-385-rd.dts |  4 ++++
>>  arch/arm/boot/dts/armada-38x.dtsi   | 17 +++++++++++++++++
>>  3 files changed, 29 insertions(+)
> [...]
>> diff --git a/arch/arm/boot/dts/armada-38x.dtsi b/arch/arm/boot/dts/armada-38x.dtsi
>> index a064f59da02d..4f117e66aa1a 100644
>> --- a/arch/arm/boot/dts/armada-38x.dtsi
>> +++ b/arch/arm/boot/dts/armada-38x.dtsi
>> @@ -355,6 +355,23 @@
>>  				clocks = <&coredivclk 0>;
>>  				status = "disabled";
>>  			};
>> +
>> +			usb3@f0000 {
>> +				compatible = "marvell,xhci-armada-380";
>> +				reg = <0xf0000 0x3fff>,<0xf4000 0x3fff>;
>> +				interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&gateclk 9>;
> 
> Using generic PHY framework will allow you to reference the PHY nodes
> with "usb-phy" here.
> 
> BTW, you added a "marvell,armada-380-usb-utmi" in the patch for PHY init
> but I can see no corresponding node added.

Yes a commit was lost during one of my rebase!
Thanks to git reflog, I found it.
Thanks,

Gregory


> 
> Sebastian
> 
>> +				status = "disabled";
>> +			};
>> +
>> +			usb3@f8000 {
>> +				compatible = "marvell,xhci-armada-380";
>> +				reg = <0xf8000 0x3fff>,<0xfc000 0x3fff>;
>> +				interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&gateclk 10>;
>> +				status = "disabled";
>> +			};
>> +
>>  		};
>>  	};
>>  
>>
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
