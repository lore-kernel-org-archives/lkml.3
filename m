Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaEGPaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:30:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54737 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbaEGPaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:30:20 -0400
Message-ID: <536A515F.3010402@ti.com>
Date: Wed, 7 May 2014 10:29:35 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Darren Etheridge <detheridge@ti.com>, Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <bcousson@baylibre.com>,
        <robherring2@gmail.com>
Subject: Re: [PATCH V6 0/2] arm: dts: dra7: Updates for adding crossbar device
References: <1399464998-23216-1-git-send-email-r.sricharan@ti.com> <20140507145656.GG2626@ti.com>
In-Reply-To: <20140507145656.GG2626@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

On 05/07/2014 09:56 AM, Darren Etheridge wrote:
> Sricharan R <r.sricharan@ti.com> wrote on Wed [2014-May-07 17:46:36 +0530]:
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
>> This is a rebase on top of 3.15-rc4
>>
>> This series depends on crossbar-driver-fixes sent below
>> http://marc.info/?l=linux-omap&m=139929963420299&w=2
>>
>> [V6] Reordered patch 3 to patch 1 and
>>      squashed patch 2 and 3 from V5 in to patch 2
>>
>> Sricharan R (2):
>>   arm: dts: dra7: Add routable-irqs property for gic node
>>   arm: dts: dra7: Add crossbar device binding
>>
> 
> Just for thoroughness I dropped the previous 3 patch series from my
> build and replaced with this two patch series.  Everything still works
> with my test setup so I consider these patches good.
> 

It looks like in further tests, there may be more interrupts like irq
10 which are not documented properly and if mapped results in the
feature not working. It does seem that we might need more detailed
validation as this seems to have skipped our "non-OS validation" flow
unfortunately. we are in discussion with silicon folks on these
"undocumented behavior" we are discovering :(.

I suggest holding the series till we have done complete validation of
the same and explanation for the behavior we see.

-- 
Regards,
Nishanth Menon
