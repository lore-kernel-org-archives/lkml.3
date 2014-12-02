Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbaLBNWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:22:35 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44048 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaLBNWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:22:34 -0500
MIME-Version: 1.0
In-Reply-To: <1416581603-30557-1-git-send-email-daniel.thompson@linaro.org>
References: <1416581603-30557-1-git-send-email-daniel.thompson@linaro.org>
Date: Tue, 2 Dec 2014 14:22:33 +0100
Message-ID: <CACRpkdaof9hW2rbH4eDNWMCiaW7+aNE_2TNyMbz+B4aqaJfsgw@mail.gmail.com>
Subject: Re: [PATCH] arm: perf: Directly handle SMP platforms with one SPI
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Patch Tracking <patches@linaro.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 3:53 PM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:

> Some ARM platforms mux the PMU interrupt of every core into a single
> SPI. On such platforms if the PMU of any core except 0 raises an interrupt
> then it cannot be serviced and eventually, if you are lucky, the spurious
> irq detection might forcefully disable the interrupt.
>
> On these SoCs it is not possible to determine which core raised the
> interrupt so workaround this issue by queuing irqwork on the other
> cores whenever the primary interrupt handler is unable to service the
> interrupt.
>
> The u8500 platform has an alternative workaround that dynamically alters
> the affinity of the PMU interrupt. This workaround logic is no longer
> required so the original code is removed as is the hook it relied upon.
>
> Tested on imx6q (which has fours cores/PMUs all muxed to a single SPI).
>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>

After som pain I managed to compile and test this with perf.
Works like a charm.

Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
