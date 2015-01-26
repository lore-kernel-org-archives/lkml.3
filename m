Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbbAZKRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:17:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:45422 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbbAZKRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:17:20 -0500
Date: Mon, 26 Jan 2015 11:16:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Agner <stefan@agner.ch>
cc: jason@lakedaemon.net, marc.zyngier@arm.com, u.kleine-koenig@pengutronix.de,
        shawn.guo@linaro.org, kernel@pengutronix.de, arnd@arndb.de,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3 0/3] irqchip: vf610-mscm: add support for MSCM
 interrupt router
In-Reply-To: <1421309046-22452-1-git-send-email-stefan@agner.ch>
Message-ID: <alpine.DEB.2.11.1501261115300.5526@nanos>
References: <1421309046-22452-1-git-send-email-stefan@agner.ch>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, Stefan Agner wrote:

> Splitted out version of the MSCM driver. My first driver based on the
> routeable domain support and was part of the Vybrid Cortex-M4 support
> patchset.
> 
> So far the MSCM interrupt router was initialized by the boot loader
> and configured all interrupts for the Cortex-A5 CPU. There are two
> use cases where a proper driver is necessary:
> - To run Linux on the Cortex-M4. When the kernel is running on the
>   non-preconfigured CPU, the interrupt router need to be configured
>   properly.
> - To support deeper sleep modes: LPSTOP clears the interrupt router
>   configuration, hence a driver needs to restore the configuration
>   on resume.
> I created a seperate patchset for that driver which hopefully makes
> it easier to get it into mergeable state.
> 
> Since I identified some registers likely to be used by other drivers
> (e.g. CPU ID or the CPU Generate Interrupt Register) I also added
> the "syscon" compatible string to make the registers available for
> other drivers in case needed.
> 
> This resend version of this patchset is rebased on v3.19-rc4.

Has the discussion with Marc on the original V3 set been resolved?

What about the DT bindings? I'm relucant to pick that up w/o acks from
the DT folks.

Thanks,

	tglx
