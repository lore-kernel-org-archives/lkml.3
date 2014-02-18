Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaBRUNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:13:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:45501 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaBRUNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:13:34 -0500
Date: Tue, 18 Feb 2014 21:13:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: carl peng <carlpeng008@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        pingfank@linux.vnet.ibm.com, yoshihiro.yunomae.ez@hitachi.com,
        linux-kernel@vger.kernel.org
Subject: Re: Does it need to implement irq_set_type method in the
 ioapic_chip?
In-Reply-To: <CAC5e1FoLrHWSa_7BnRt-u451ZJOVqKhSpbyp8O_ExDbgcXtU+g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402182101450.4468@ionos.tec.linutronix.de>
References: <CAC5e1FoLrHWSa_7BnRt-u451ZJOVqKhSpbyp8O_ExDbgcXtU+g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, carl peng wrote:

Carl, sending the same mail twice within an hour does not speed up
things. It's quite likely that it gets ignored.

> 1. Does it need to implement irq_set_type method in the ioapic_chip
> structure?

No. The irq type is configured by the type of the interrupt or the
BIOS.

ISA  interrupts are always polarity zero edge triggered (historic)

PCI  interrupts are always polarity one level triggered

PCIE interrupts are either legacy PCI or with MSI[X] always edge
     triggered

> 2. if no need to implement it, how can device driver set the trigger mode
> of APIC interrupt controller pin?

Not at all.

The device which is connected to one of the busses must follow the
specification of the bus. There is no choice. Any additional
requirements of the device to deal with external signals must be
handled by the device itself and converted to the appropriate bus
requirement.

This all is configured by the kernel automatically through bus
detection and BIOS tables.

Thanks,

	tglx
