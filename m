Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaHaRfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 13:35:51 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:43674 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaHaRft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 13:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <1409350479-19108-2-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <1409350479-19108-2-git-send-email-abrestic@chromium.org>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 31 Aug 2014 19:34:55 +0200
Message-ID: <CAOiHx=kKzkSD7fRK+dO97HzrifBuaN4gw8XM-47Af0P077d7TQ@mail.gmail.com>
Subject: Re: [PATCH 01/12] MIPS: Provide a generic plat_irq_dispatch
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 12:14 AM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> For platforms which boot with device-tree and use the MIPS CPU interrupt
> controller binding, a generic plat_irq_dispatch() can be used since all
> CPU interrupts should be mapped through the CPU IRQ domain.  Implement a
> plat_irq_dispatch() which simply handles the highest pending interrupt.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>

I gave this a short test by hackishly adding IRQ_DOMAIN support to
bcm63xx and removing the local plat_irq_dispatch, and it booted fine,
and cascaded interrupts were still working. Therefore

Tested-by: Jonas Gorski <jogo@openwrt.org>


Jonas
