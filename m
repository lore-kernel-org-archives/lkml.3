Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbaJaJ5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:57:50 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:60920 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbaJaJ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <5450CCE7.7010803@arm.com>
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
	<1414232097-4328-2-git-send-email-marc.zyngier@arm.com>
	<CACRpkdZjUPV1eWcJjT587kxJm2zyC+OEYD0Deid4wYPh8A-Z4w@mail.gmail.com>
	<5450CCE7.7010803@arm.com>
Date: Fri, 31 Oct 2014 10:57:44 +0100
Message-ID: <CACRpkdadiT3QGnCp+1h-R1rLhfgYSor3KLfd0MUR=cBe0haU-Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] genirq: Allow the irqchip state of an IRQ to be save/restored
From: Linus Walleij <linus.walleij@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Tin Huynh <tnhuynh@apm.com>, Y Vo <yvo@apm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Toan Le <toanle@apm.com>,
        Bjorn Andersson <bjorn@kryo.se>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:17 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 29/10/14 10:12, Linus Walleij wrote:
>> On Sat, Oct 25, 2014 at 12:14 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>
>>> There is a number of cases where a kernel subsystem may want to
>>> introspect the state of an interrupt at the irqchip level:
>>>
>>> - When a peripheral is shared between virtual machines, its interrupt
>>>   state becomes part of the guest's state, and must be switched accordingly.
>>>   KVM on arm/arm64 requires this for its guest-visible timer
>>> - Some GPIO controllers seem to require peeking into the interrupt controller
>>>   they are connected to to report their internal state
>>
>> I'd like to know exactly what this means, for GPIO. As mentioned in
>> conversation with Arnd, there is since before the case where a GPIO
>> irqchip gets its irqs "stolen" by some other hardware that is in the
>> always-on domain, and I call these "latent irqs".
>
> It looks like a slightly different issue:
> http://patchwork.ozlabs.org/patch/397657/
>
> Basically, the GPIO chip cannot report its own state, and has to
> introspect the parent irqchip to find out.

That's incidentally the same problem as in the Integrator/CP,
wowsers. What goes around comes around.

>> This just goes in and peeks around in the Integrator SIC, this
>> patch would solve also this I think. Or are the added calls good
>> for clearing the latched IRQ too?
>
> Pretty funky. You could also use this to clear the pending bit (assuming
> there is one on the CP). I'm amazed at the number of similar hacks that
> are coming out of the wood now...

Yeah we should have fixed this with the Integrator in 2001 or so.
Not too late anyways, let's clean it out now :)

Yours,
Linus Walleij
