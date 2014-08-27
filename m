Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbaH0Kgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:36:42 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:39392 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933410AbaH0Kgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:36:40 -0400
Message-ID: <53FDB4B3.6000400@arm.com>
Date: Wed, 27 Aug 2014 11:36:35 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?windows-1252?Q?Jan_L=FCbbe?= <jlu@pengutronix.de>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "Joe.C" <srv_yingjoe.chen@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [RESEND PATCH v2 1/4] irqchip: gic: Change irq type check when
 extension is present
References: <1407895884-18131-1-git-send-email-srv_yingjoe.chen@mediatek.com> <1407895884-18131-2-git-send-email-srv_yingjoe.chen@mediatek.com> <53F724F5.3040004@arm.com> <1409133344.25382.37.camel@coredoba.hi.pengutronix.de>
In-Reply-To: <1409133344.25382.37.camel@coredoba.hi.pengutronix.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On 27/08/14 10:55, Jan Lübbe wrote:
> Marc,
> 
> On Fri, 2014-08-22 at 12:09 +0100, Marc Zyngier wrote:
>> Here, you're using it to program something that sits between the
>> device and the GIC. This is a separate block, with its own hardware
>> configuration, that modifies the interrupt signal. This should be
>> reflected in the device-tree and the code paths.
>>
>> You can probably model this as a separate irqchip for the few
>> interrupts that require this, or have it configured at boot time
>> (assuming the configuration never changes).
> 
> It seems to me that using a separate irqchip for a simple inverter would
> add the run-time overhead of passing through wrapper functions on every
> IRQ. Do you have an idea how this could be avoided without using the
> gic_arch_extn feature?

Well, from the rather vague description, it could be slightly more than
a simple inverter, like being able to generate interrupts on both rising
and falling edges. Sorry, but this is not the GIC as ARM has architected it.

Yes, the additional irqchip adds some overhead. But the DT has to
reflect the fact that there is something on the interrupt path that does
some form of conversion.

> As in the DT the actual IRQ polarity should be used, simply configuring
> the HW IRQ polarity in the bootloader is not enough without telling the
> GIC driver which polarity is supported on which IRQ, right?

Looking a bit closer at things, what you describe in DT is the IRQ
polarity the interrupt controller sees. Nothing else should interpret
that field.

So it is legal (IMO) to have a device with an interrupt specifier
describing a rising edge interrupt, and yet have the device generating a
falling edge, with Mediatek's special sauce doing the conversion in between.

Something will have to configure the polarity widget though, but that
can be left outside of the GIC.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
