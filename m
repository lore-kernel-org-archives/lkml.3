Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaEFTq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:46:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34858 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaEFTq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:46:56 -0400
Message-ID: <53693C02.2090305@ti.com>
Date: Tue, 6 May 2014 14:46:10 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <balbi@ti.com>, Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <bcousson@baylibre.com>,
        <robherring2@gmail.com>
Subject: Re: [PATCH V5 1/3] arm: dts: dra7: Add crossbar device binding
References: <1399384579-25620-1-git-send-email-r.sricharan@ti.com> <1399384579-25620-2-git-send-email-r.sricharan@ti.com> <20140506194055.GA6962@saruman.home>
In-Reply-To: <20140506194055.GA6962@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 02:40 PM, Felipe Balbi wrote:
> On Tue, May 06, 2014 at 07:26:17PM +0530, Sricharan R wrote:
>> This adds the irq crossbar device node.
>>
>> There is a IRQ crossbar device in the soc, which
>> maps the irq requests from the peripherals to the
>> mpu interrupt controller's inputs. The Peripheral irq
>> requests are connected to only one crossbar
>> input and the output of the crossbar is connected to only one
>> controller's input line. The crossbar device is used to map
>> a peripheral input to a free mpu's interrupt controller line.
>>
>> Cc: Benoit Cousson <bcousson@baylibre.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Cc: Rajendra Nayak <rnayak@ti.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>> [V5] Rebased on top of 3.15-rc4 and corrected the
>>      irqs-reserved list
>>
>>  arch/arm/boot/dts/dra7.dtsi |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
>> index 149b550..0274a86 100644
>> --- a/arch/arm/boot/dts/dra7.dtsi
>> +++ b/arch/arm/boot/dts/dra7.dtsi
>> @@ -790,6 +790,14 @@
>>  			status = "disabled";
>>  		};
>>  	};
>> +
>> +	crossbar_mpu: crossbar@4a020000 {
> 
> shouldn't this be "status = disabled"; so that boards enable this
> on-demand ??
> 
It cannot be and does not need to be. crossbar is an SoC feature. by
defining crossbar, the IRQ numbers we provide in DTS now becomes
crossbar numbers which get mapped to GIC interrupt numbers dynamically.

further crossbar is not a board feature. it is as ingrained in DRA7
behavior as GIC is. we are fortunate that we have some default mapping
of crossbar that allows the current peripherals to work, with this
support, we dont have to depend any longer on "we are lucky that is
mapped".

That said, in hindsight, patch #1 and 2 should be squashed IMHO. else
we have a bisectability problem here.

-- 
Regards,
Nishanth Menon
