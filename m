Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaLTWzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:55:16 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:51871 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLTWzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:55:14 -0500
MIME-Version: 1.0
In-Reply-To: <3669965.zfJEHTFEBI@wuerfel>
References: <1418825853-10934-1-git-send-email-eddie.huang@mediatek.com>
 <20141217143305.GC8942@leverpostej> <54919AC9.2090306@arm.com> <3669965.zfJEHTFEBI@wuerfel>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Sat, 20 Dec 2014 22:54:52 +0000
Message-ID: <CAFEAcA-+2G_F1Qp30BipY=wq-HdXSvKv0OArOJBcp8fGg0hPMQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] arm64: dts: Add mediatek MT8173 SoC and evaluation
 board dts and Makefile
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Brown <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 December 2014 at 20:07, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 17 December 2014 15:01:29 Marc Zyngier wrote:
>> Also it is worth noticing that given how GICV is placed, it will never
>> work with 64K pages and virtualization. Pretty sad.
>
> Does this mean no VGIC support on this platform so you have to emulate it
> in order to run virtual machines with 64K pages, or does it mean that
> it's impossible to use that way because you can't emulate it?

Currently having the guest use the generic timer requires an
in-kernel GIC, because we don't provide an ABI for having the
kernel say "here is a generic timer interrupt for the userspace
emulated GIC". And at least for QEMU userspace the "virt" board
doesn't provide any other kind of timer, so you'd need to add one
if you wanted to use a userspace GIC. So for practical purposes
"out-of-kernel GIC" is not a supported config for KVM+QEMU.

-- PMM
