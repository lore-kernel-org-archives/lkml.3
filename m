Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab3LESsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:48:55 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55307 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025Ab3LESsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:48:53 -0500
MIME-Version: 1.0
In-Reply-To: <201312031601.04997.arnd@arndb.de>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
 <1385511748-27869-2-git-send-email-marc.ceeeee@gmail.com> <201312031601.04997.arnd@arndb.de>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 5 Dec 2013 10:48:12 -0800
Message-ID: <CAGVrzcbxHA+S0yZbsrj8uMZR0hsb_ng=PB02zte7S0rCZWQpBg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] ARM: brcmstb: add infrastructure for ARM-based
 Broadcom STB SoCs
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Carino <marc.ceeeee@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

2013/12/3 Arnd Bergmann <arnd@arndb.de>:
>
>> +     addr = ioremap(BPHYSADDR(BCHP_IRQ0_IRQEN), sizeof(u32));
>> +     writel_relaxed(BCHP_IRQ0_IRQEN_uarta_irqen_MASK
>> +             | BCHP_IRQ0_IRQEN_uartb_irqen_MASK
>> +             | BCHP_IRQ0_IRQEN_uartc_irqen_MASK, addr);
>> +     iounmap(addr);
>
> What does this part do? Isn't that something that should have been set
> up by the boot loader?

The bootloader will typically use the UART in busy-looping mode and
not rely on interrupts, also the bootloader currently does not know
much about how many UARTs there are in the system and how they are
going to be used.

One possible way to solve this would be to write a very small irqchip
driver which only implements the "irq_enable" method to allow these
interrupts to be forwarded to the GIC. Somewhere in the Device Tree we
would have an interrupt-map property which describes the mapping
between the bits in BCHP_IRQ0_IRQEN and their corresponding
peripherals (UARTA, B, C).

Would that work?
-- 
Florian
