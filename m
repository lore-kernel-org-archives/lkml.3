Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbaJ3KnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:43:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:34023 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbaJ3KnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:43:04 -0400
Date: Thu, 30 Oct 2014 11:43:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Kevin Cernekee <cernekee@gmail.com>, f.fainelli@gmail.com,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH V2 02/15] sh: Eliminate unused irq_reg_{readl,writel}
 accessors
In-Reply-To: <2294092.AHz8W66sEP@wuerfel>
Message-ID: <alpine.DEB.2.11.1410301142010.5308@nanos>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-3-git-send-email-cernekee@gmail.com> <2294092.AHz8W66sEP@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Arnd Bergmann wrote:

> On Wednesday 29 October 2014 19:17:55 Kevin Cernekee wrote:
> > Defining these macros way down in arch/sh/.../irq.c doesn't cause
> > kernel/irq/generic-chip.c to use them.  As far as I can tell this code
> > has no effect.
> > 
> > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 
> Actually it overrides the 32-bit accessors with 16-bit accessors,
> which does seem intentional and certainly has an effect.

Not really. Neither arch/sh/boards/mach-se/7343/irq.c nor
arch/sh/boards/mach-se/7722/irq.c actually use
irq_reg_readl/writel. They simply define it.
 
Thanks,

	tglx
