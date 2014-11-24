Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaKXVaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:30:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:41478 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKXVaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:30:06 -0500
Date: Mon, 24 Nov 2014 22:29:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, patches@linaro.org,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.18-rc3 v8 1/4] irqchip: gic: Make gic_raise_softirq()
 FIQ-safe
In-Reply-To: <54739CA8.2080406@linaro.org>
Message-ID: <alpine.DEB.2.11.1411242219030.6439@nanos>
References: <1415183260-6389-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-2-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411241918090.6439@nanos>
 <alpine.DEB.2.11.1411241928300.6439@nanos> <alpine.DEB.2.11.1411242101130.6439@nanos> <54739CA8.2080406@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Daniel Thompson wrote:
> On 24/11/14 20:38, Thomas Gleixner wrote:
> > So while I cannot come up with a brilliant replacement, it would be
> > really helpful documentation wise if you could do the following:
> > 
> > 1) Create a patch which introduces irq_migration_lock as a raw
> >    spinlock and replaces the usage of irq_controller_lock in
> >    gic_raise_softirq() and gic_migrate_target() along with a proper
> >    explanation in the code and the changelog of course.
> 
> Replace irq_controller_lock or augment it with a new one?

Replace it in gic_raise_softirq() and add it to gic_migrate_target()
as you did with the RW lock.
 
Thanks,

	tglx

