Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaJYSt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:49:59 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48618 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaJYStv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:49:51 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
In-Reply-To: <CAJAp7OjQ8qRspy_ocUnp+es+HPiR1jULhKK6g4DBXXZcOsABug@mail.gmail.com>
	(Bjorn Andersson's message of "Sat, 25 Oct 2014 00:12:55 +0100")
Organization: ARM Ltd
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com>
	<CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com>
	<alpine.DEB.2.11.1410211120430.5308@nanos> <544628BF.8010809@arm.com>
	<CAJAp7OjpN-+S=OH1BW6Fcme9mp4qj8AsSNC3_41fhfpYzX-Shg@mail.gmail.com>
	<544A936D.5040409@arm.com>
	<CAJAp7OjQ8qRspy_ocUnp+es+HPiR1jULhKK6g4DBXXZcOsABug@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Sat, 25 Oct 2014 10:22:57 +0100
Message-ID: <874musjyfi.fsf@why.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25 2014 at 12:12:55 am BST, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Fri, Oct 24, 2014 at 10:59 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> I just pushed out a branch:
>> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
>> irq/irqchip_state
>>
>> Please let me know if that's useful for you.
>>
>
> I think that my irq_read_line() would be equivalent of
> irq_get_irqchip_state(IRQCHIP_STATE_PENDING), i.e. the state of the
> interrupt ignoring masking. And the rest would be EINVAL.
> So I think this would work out just fine for us!

Excellent.

> Is ACTIVE the line level with the mask considered and setting ACTIVE,
> would that be the same as acking the interrupt?

ACTIVE describes the state that exists once the interrupt has been
ACKed, and before it has been EOIed. It indicates an interrupt "in
progress".

It probably doesn't make any sense for most users, but is extremely
useful with KVM: when a device is shared between VMs (most obvious one
is a simple timer), the interrupt state is part of the whole context,
and must be save/restored as well.

> What's the expected behaviour of setting PENDING?

Its expected behaviour is to inject an interrupt, just as if the device
signaled an interrupt. Probably not easy to implement on anything but
the ARM GICs.

> I would appreciate if you commented the state enum, to make it obvious
> what pending and active means.

Done. I'll probably post this today.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
