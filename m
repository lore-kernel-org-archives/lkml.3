Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3JHLXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:23:04 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33644 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3JHLXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <524987A3.4090204@arm.com>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
	<1380549564-31045-2-git-send-email-r.sricharan@ti.com>
	<524987A3.4090204@arm.com>
Date: Tue, 8 Oct 2013 13:23:00 +0200
Message-ID: <CACRpkdac5iPqwv2Wb2uksn=cYtS0r=1+tSr4Cre2Xun0JBKzpA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] DRIVERS: IRQCHIP: IRQ-GIC: Add support for
 routable irqs
From: Linus Walleij <linus.walleij@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Sricharan R <r.sricharan@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>, "rnayak@ti.com" <rnayak@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 4:16 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 30/09/13 14:59, Sricharan R wrote:
>> In some socs the gic can be preceded by a crossbar IP which
>> routes the peripheral interrupts to the gic inputs. The peripheral
>> interrupts are associated with a fixed crossbar input line and the
>> crossbar routes that to one of the free gic input line.
>>
>> The DT entries for peripherals provides the fixed crossbar input line
>> as its interrupt number and the mapping code should associate this with
>> a free gic input line. This patch adds the support inside the gic irqchip
>> to handle such routable irqs. The routable irqs are registered in a linear
>> domain. The registered routable domain's callback should be implemented
>> to get a free irq and to configure the IP to route it.
>
> Isn't this just another chained interrupt controller? How is it GIC
> specific?

I thought so from the beginning but I was dead wrong, as pointed out
by tglx it is basically a hardware .map function, so its usecase will map
to the irqdomain .map/.unmap so to say.

Yours,
Linus Walleij
