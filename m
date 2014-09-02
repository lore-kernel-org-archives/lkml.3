Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaIBXDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:03:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:40146 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaIBXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:03:07 -0400
Date: Wed, 3 Sep 2014 01:02:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>, patches@linaro.org,
        kgdb-bugreport@lists.sourceforge.net, Nicolas Pitre <nico@linaro.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Fabio Estevam <festevam@gmail.com>, Colin Cross <ccross@android.com>,
        kernel-team@android.com, Dave Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 00/19] arm: KGDB NMI/FIQ support
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.10.1409030032010.3333@nanos>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Daniel Thompson wrote:

> This patchset makes it possible to use kgdb's NMI infrastructure on ARM
> platforms.
> 
> The patches are seperated into three distinct groups:
> 
> 1. arm specific changes; these provide multi-platform support for FIQ
>    (including raising an IPI using FIQ to ensure effective SMP support)
>    and extend ARM KGDB support to use the features provided.
> 
> 2. irqchip changes; updates to the gic and vic drivers to provide
>    support for routing certain interrupt sources to FIQ.
> 
> 3. serial changes; driver support to allow the UART interrupt to be
>    routed to FIQ. The already mainlined kgdb NMI infrastructure (mostly
>    found in drivers/tty/serial/kgdb_nmi.c) will re-route the kgdb
>    console UART's interrupt signal from IRQ to FIQ. Naturally the UART
>    will no longer function normally and will instead be managed by kgdb
>    using the polled I/O functions. Any character delivered to the UART
>    causes the kgdb handler function to be called.

To be honest, what you are doing is just ass backwards.

The use case you are looking for is the most irrelevant of all. Just
because KGDB is on some managerial "must have items" checklist does
not make it useful.

The only relevant use cases of FIQs are the same as those of NMIs on
x86:

  - Watchdog to detect stuck cpus and issue stack traces

  - Performace monitoring

KGDB falls into place once you solved the above.

That said for the general approach, I'll have a look at the irq
related patches in a minute.

Thanks,

	tglx

