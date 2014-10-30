Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbaJ3JHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:07:08 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65232 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311AbaJ3JHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:07:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Cernekee <cernekee@gmail.com>, f.fainelli@gmail.com,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH V2 03/15] genirq: Generic chip: Move irq_reg_{readl,writel} accessors into generic-chip.c
Date: Thu, 30 Oct 2014 10:06:51 +0100
Message-ID: <6552163.gt4ABVyYlA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410300941290.5308@nanos>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-4-git-send-email-cernekee@gmail.com> <alpine.DEB.2.11.1410300941290.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gfzDjLTecc2L7VX+0HAgY1/wdJkjqZy0Zay/zOLZhK+
 Vu0K7I+ZdhuxNrAMlbkpvua7VgTqt+8KyXnmN4YcC0WhxrGQkY
 sz9oKRqbxbNMj7665jbwkg2jqNuW2HJROWVL2PLPH6iEqhjgCp
 +cAMhwWdNhHfLrVqrCHl3CzxMmO7pni5859GKPVg5K2E/ZYvqX
 m1nrzDt1Js2pcMnxprF8D/A/CrzS7he5lJh4t0wmnX5aehJ/V8
 7lniCt7Aokd8TraRH+/Ei+ibpm9y+vYynXfn2JpzJ7KXrWOJks
 HAM8SBz4kzZypukJ/a3omRvt74bfs/PmE+XlILmnTeTswEQtw0
 VWJu55w0FDlDkzeReqnw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 09:43:02 Thomas Gleixner wrote:
> > diff --git a/include/linux/irq.h b/include/linux/irq.h
> > index 03f48d9..8049e93 100644
> > --- a/include/linux/irq.h
> > +++ b/include/linux/irq.h
> > @@ -639,13 +639,6 @@ void arch_teardown_hwirq(unsigned int irq);
> >  void irq_init_desc(unsigned int irq);
> >  #endif
> >  
> > -#ifndef irq_reg_writel
> > -# define irq_reg_writel(val, addr)   writel(val, addr)
> > -#endif
> > -#ifndef irq_reg_readl
> > -# define irq_reg_readl(addr)         readl(addr)
> > -#endif
> > -
> 
> Brilliant patch that.
> 
> # git grep -l irq_reg_readl drivers/irqchip/
> drivers/irqchip/irq-atmel-aic.c
> drivers/irqchip/irq-atmel-aic5.c
> drivers/irqchip/irq-sunxi-nmi.c
> drivers/irqchip/irq-tb10x.c

Patch 1/15 changes these all. I think it's still broken because patch 2/15
is wrong, but it's not /that/ obviously broken.

	Arnd
