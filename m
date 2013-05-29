Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3E2FOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:14:50 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33537 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3E2FOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:14:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv4 1/6] arm: TI-Nspire platform code
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201305271715.02385.arnd@arndb.de>
Date: Wed, 29 May 2013 15:14:41 +1000
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <10704A21-6BEC-42DC-BB1E-88A0E87D288B@gmail.com>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305270856.19456.arnd@arndb.de> <CAPnH9dnA22C3ZS9jgJNytnmKM_8Vfk7OxNRB1Mg03=q7KhHZBA@mail.gmail.com> <201305271715.02385.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28/05/2013, at 1:15 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 27 May 2013, Daniel Tang wrote:
>> Before any peripheral is accessed. I.e. before the clocksource and irqchip
>> drivers.
> 
> The irqchip comes first, and by that time, you can actually call
> of_iomap().
> 
>> The write to the port is supposed to ensure all mmio peripherals can be
>> accessed. Without it, access to certain peripherals will result in
>> undefined reads or ignored writes.
>> 
>> On second thoughts, would this actually be the job of the boot loader?
> 
> Doing it in the boot loader would certainly simplify things. I wonder
> about the dynamic aspects of power management though: It might be
> better to expose the individual bits of this register through a proper
> driver. The boot loader can start out enabling everything, but then
> you turn off everything that is not needed when that driver gets
> loaded.

That's the idea for the long term.

For now though, I'll probably just let the bootloader enable everything and work on a proper driver for power management later.

> 
> I'm still not sure what the register actually does: Does it
> control reset lines, clock signals, voltage regulators or something
> else? These things all have their own subsystems, and then there
> is also the power domain framework.

To be perfectly honest, I'm not too sure. The documentation for the TI-Nspire is all gathered from reverse engineering and all it says is that register "disables bus access to peripherals".

> 
> 	Arnd

Cheers,
Daniel Tang