Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaEHIPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:15:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50003 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaEHIPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:15:32 -0400
Message-ID: <536B3CB0.2050907@ti.com>
Date: Thu, 8 May 2014 13:43:36 +0530
From: Archit Taneja <archit@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Darren Etheridge <detheridge@ti.com>, Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <nm@ti.com>, <bcousson@baylibre.com>,
        <robherring2@gmail.com>
Subject: Re: [PATCH V5 0/3] arm: dts: dra7: Updates for adding crossbar device
References: <1399384579-25620-1-git-send-email-r.sricharan@ti.com> <20140506214526.GF2626@ti.com>
In-Reply-To: <20140506214526.GF2626@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.145.166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2014 03:15 AM, Darren Etheridge wrote:
> Sricharan R <r.sricharan@ti.com> wrote on Tue [2014-May-06 19:26:16 +0530]:
>> Some socs have a large number of interrupts requests to service
>> the needs of its many peripherals and subsystems. All of the interrupt
>> requests lines from the subsystems are not needed at the same
>> time, so they have to be muxed to the controllers appropriately.
>> In such places a interrupt controllers are preceded by an
>> IRQ CROSSBAR that provides flexibility in muxing the device interrupt
>> requests to the controller inputs.
>>
>> The dts file update to support the crossbar device and convert
>> peripheral irq numbers to crossbar number are added here.
>>
>> This is a rebase of V4 series on top of 3.15-rc4
>>
>> This series depends on crossbar-driver-fixes sent below
>> http://marc.info/?l=linux-omap&m=139929963420299&w=2
>>
>> Sricharan R (3):
>>    arm: dts: dra7: Add crossbar device binding
>>    arm: dts: dra7: Replace peripheral interrupt numbers with crossbar
>>      inputs
>>    arm: dts: dra7: Add routable-irqs property for gic node
>>
>
> OK, assuming the bisectability issues discussed earlier on this thread
> are addressed.  I have tested the earlier crossbar patch series in
> conjunction with this dts series with VIP capture and DSS display
> running together on DRA7.  Looks good with this combination of
> devices. VIP is one of the modules that must have a crossbar mapping as
> there is no default interrupt mapping for it, therefore VIP makes a good
> test case.
>
> So please feel free to add:
>
> Tested-by: Darren Etheridge <detheridge@ti.com>

DMM doesn't get used by default since it's hwmod is missing in DRA7x's 
hwmod data. I added the hwmod and tried using dmm with omapdrm, it works 
fine.

So, for DSS and DMM:

Tested-by: Archit Taneja <archit@ti.com>

>
>
>>   arch/arm/boot/dts/dra7.dtsi |  109 +++++++++++++++++++++++++------------------
>>   1 file changed, 63 insertions(+), 46 deletions(-)
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

