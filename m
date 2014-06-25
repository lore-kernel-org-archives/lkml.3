Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaFYOG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:06:58 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:41566 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165AbaFYOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:06:55 -0400
MIME-Version: 1.0
In-Reply-To: <1403688530-23273-4-git-send-email-marc.zyngier@arm.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com> <1403688530-23273-4-git-send-email-marc.zyngier@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 25 Jun 2014 15:06:33 +0100
Message-ID: <CAFEAcA_naeGVc+Rsec=Ds6Lzf345nzFj3Wg2RWY-6LWYv3euNQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 June 2014 10:28, Marc Zyngier <marc.zyngier@arm.com> wrote:
> For this case, the GIC architecture provides EOImode == 1, where:
> - A write to the EOI register drops the priority of the interrupt and leaves
> it active. Other interrupts at the same priority level can now be taken,
> but the active interrupt cannot be taken again
> - A write to the DIR marks the interrupt as inactive, meaning it can
> now be taken again.
>
> We only enable this feature when booted in HYP mode. Also, as most device
> trees are broken (they report the CPU interface size to be 4kB, while
> the GICv2 CPU interface size is 8kB), output a warning if we're booted
> in HYP mode, and disable the feature.

Does that mean you guarantee not to write to the DEACTIVATE
register if not booted in Hyp mode? I ask because QEMU's
GIC emulation doesn't emulate that register, so it would be
useful to know if this patch means newer kernels are going to fall
over under TCG QEMU...

(The correct fix, obviously, is to actually implement the QEMU
support for split prio-drop and deactivate. Christoffer, you're our
GIC emulation expert now, right? :-) )

thanks
-- PMM
