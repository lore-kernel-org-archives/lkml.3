Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3LEUH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:07:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3LEUHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:07:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 1/6] ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
Date: Thu, 5 Dec 2013 21:07:06 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Marc Carino <marc.ceeeee@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com> <201312031601.04997.arnd@arndb.de> <CAGVrzcbxHA+S0yZbsrj8uMZR0hsb_ng=PB02zte7S0rCZWQpBg@mail.gmail.com>
In-Reply-To: <CAGVrzcbxHA+S0yZbsrj8uMZR0hsb_ng=PB02zte7S0rCZWQpBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312052107.07197.arnd@arndb.de>
X-Provags-ID: V02:K0:SiF/3UmP71AiDP056GSAymRnOoWRui1LMlzv0ZronCf
 j2bKgclfTpbKBMkRiV5iymiwUvLg8h2nvOpksHOY3W2T2HV0Yl
 Ky6yswNRQwjU3TfMQRm3HZZoezwH9vvEHqLsLfT/e8FdC/afBA
 xcWGMOQ2XSTN8KMVWrnJ31fCNqAZ+w1PSSVrmI6X6B8kyCAVWh
 /KPwudhGCma15Go0sAryKlL9UcOlAccJiErP+DHOwFlsqRkw4l
 um8T0Vy6H/KY5LxI/Px+I/0uO7YLad2aZ4rwcYU5FUeh/8uQdU
 3GZPy/Jpxsznv6QRfTE9TYlfcXvTXc+ILJBf6ZL4hHImYMcqEO
 QRkhGvzmZIiwr3mNT/zc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 December 2013, Florian Fainelli wrote:
> 2013/12/3 Arnd Bergmann <arnd@arndb.de>:
> >
> >> +     addr = ioremap(BPHYSADDR(BCHP_IRQ0_IRQEN), sizeof(u32));
> >> +     writel_relaxed(BCHP_IRQ0_IRQEN_uarta_irqen_MASK
> >> +             | BCHP_IRQ0_IRQEN_uartb_irqen_MASK
> >> +             | BCHP_IRQ0_IRQEN_uartc_irqen_MASK, addr);
> >> +     iounmap(addr);
> >
> > What does this part do? Isn't that something that should have been set
> > up by the boot loader?
> 
> The bootloader will typically use the UART in busy-looping mode and
> not rely on interrupts, also the bootloader currently does not know
> much about how many UARTs there are in the system and how they are
> going to be used.

Well, it should at least know how many ports are wire up and be able
to set them up to a working state.

> One possible way to solve this would be to write a very small irqchip
> driver which only implements the "irq_enable" method to allow these
> interrupts to be forwarded to the GIC. Somewhere in the Device Tree we
> would have an interrupt-map property which describes the mapping
> between the bits in BCHP_IRQ0_IRQEN and their corresponding
> peripherals (UARTA, B, C).
> 
> Would that work?

I think that would work, but it's getting into the overdesign territory.
Can you clarify why this register exists in the first place and what
makes it necessary to set it up? Are there similar registers for all
other IRQs?

	Arnd
