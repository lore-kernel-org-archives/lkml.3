Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3ILUSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:18:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:60901 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3ILUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:18:53 -0400
Date: Thu, 12 Sep 2013 22:18:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sricharan R <r.sricharan@ti.com>
cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, linux@arm.linux.org.uk, tony@atomide.com,
        rnayak@ti.com
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
In-Reply-To: <1379000351-15672-2-git-send-email-r.sricharan@ti.com>
Message-ID: <alpine.DEB.2.02.1309122201530.4089@ionos.tec.linutronix.de>
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com> <1379000351-15672-2-git-send-email-r.sricharan@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Sricharan R wrote:
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
> There is lockdep warning during the boot. This is because we try to
> do one request_irq with in another and that results in kmalloc being
> called from an atomic context, which generates the warning.
> Any suggestions to overcome this will help.

You can't be serious about that. You post a patch series with a
serious bug in it instead of asking in the first place how to solve
the problem at hand.

So why do you actually need to call request_irq() from inside
request_irq() and how do you actually manage to do that at all?

I have a hard time to figure out how request_irq() might call itself
recursive. And I have no intention to look at your patch to figure out
that you abuse an irq chip callback to do so, simply because that
would force me to use abusive language which is frowned upon nowadays.

Can you please explain what you are trying to solve without referring
to your existing broken implementation.

Thanks,

	tglx




