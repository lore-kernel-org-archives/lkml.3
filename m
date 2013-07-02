Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3GBNAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 09:00:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14674 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751134Ab3GBNAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 09:00:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Kx/EUk5MezVgB4J91YIwBfxyX2KEzRGg=
Date: Tue, 2 Jul 2013 09:00:13 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/7] ARM: kirkwood: convert to DT irqchip and
 clocksource
Message-ID: <20130702130013.GJ19937@titan.lakedaemon.net>
References: <1372763023-12374-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1372763023-12374-6-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130702115311.GG19937@titan.lakedaemon.net>
 <51D2CCC4.30109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D2CCC4.30109@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 02:51:16PM +0200, Sebastian Hesselbarth wrote:
> On 07/02/13 13:53, Jason Cooper wrote:
> >On Tue, Jul 02, 2013 at 01:03:41PM +0200, Sebastian Hesselbarth wrote:
> >>With recent support for true irqchip and clocksource drivers for Orion
> >>SoCs, now make use of it on DT enabled Kirkwood boards.
> >>
> >>This also introduces a new Kconfig option for legacy (non-DT) Kirkwood
> >>where old code is moved out to and polishes DT board file a little bit.
> >>
> >>Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >>---
> [...]
> >>diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
> >>index 881f37e..385244c 100644
> >>--- a/arch/arm/mach-kirkwood/board-dt.c
> >>+++ b/arch/arm/mach-kirkwood/board-dt.c
> >>@@ -15,6 +15,9 @@
> >>  #include <linux/of.h>
> >>  #include <linux/of_platform.h>
> >>  #include <linux/clk-provider.h>
> >>+#include <linux/clocksource.h>
> >>+#include <linux/dma-mapping.h>
> >>+#include <linux/irqchip.h>
> >>  #include <linux/kexec.h>
> >>  #include <asm/mach/arch.h>
> >>  #include <asm/mach/map.h>
> >>@@ -67,10 +70,18 @@ static void __init kirkwood_legacy_clk_init(void)
> >>  	clk_prepare_enable(clk);
> >>  }
> >>
> >>-static void __init kirkwood_of_clk_init(void)
> >>+static void __init kirkwood_dt_time_init(void)
> >>  {
> >>  	of_clk_init(NULL);
> >>-	kirkwood_legacy_clk_init();
> >>+	clocksource_of_init();
> >>+}
> >>+
> >>+static void __init kirkwood_dt_init_early(void)
> >>+{
> >
> >
> >>+	init_dma_coherent_pool_size(SZ_1M);
> >
> >This shouldn't be needed any more.  Is there a reason you're adding it
> >back in?
> 
> Jason, thanks for catching this. The last patch I had was before removal
> of init_dma_coherent_pool_size. I slipped back in because I missed the
> removal patches.

ah, ok.

> Can you remove it prior merge, should I prepare a fixup patch, or respin
> this patch?

Please check for other occurrences (all should be gone), and post a v2
of only the affected patches.

thx,

Jason.
