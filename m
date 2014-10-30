Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbaJ3JEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:04:43 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58764 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014AbaJ3JEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:04:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Kevin Cernekee <cernekee@gmail.com>, f.fainelli@gmail.com,
        tglx@linutronix.de, jason@lakedaemon.net, ralf@linux-mips.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V2 06/15] genirq: Generic chip: Optimize for fixed-endian systems
Date: Thu, 30 Oct 2014 10:04:24 +0100
Message-ID: <2089348.fa41ONzNz9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141030041658.GB29070@brian-ubuntu>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-7-git-send-email-cernekee@gmail.com> <20141030041658.GB29070@brian-ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:V9cRYoCTU+oVFZW3xLwNHYpCAX2OqEvA0Zh4+nxWtAZ
 ervurGLunJufnbQkmHnNE6bq/mr2D2sbK7nirW84Y6RS6vV6GF
 H48tv+MY/Ga6ljevDUvdTaEfzWGXVqHSwaOtTQSlNh/BRtW13D
 l7LA9V1hXUNOLjRiPi96Zs8bPLV2t2bJLILjZxMU4e0F2BKSQp
 3lrLuuzChcaoEl/Aupo/rhdMBLGw6D1ejXn9iE8KuoirHoPIs4
 ow0NdeYAqt3/SIZqKtQknZvlREveCpMvLXR8G4zNwuWea68eUu
 s5ZPKsGmEGTHXZVlF5oAY/LFlS7m6leZus64aotFZwdQAPsjub
 h0ZxC2GKv8CsxlyvgznE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 21:16:58 Brian Norris wrote:
> >  static int is_big_endian(struct irq_chip_generic *gc)
> >  {
> > -     return !!(gc->domain->gc->gc_flags & IRQ_GC_BE_IO);
> > +     if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP) &&
> > +         !IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE))
> > +             return 0;
> > +     else if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE) &&
> > +              !IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP))
> > +             return 1;
> 
> Would XOR make this any easier to read? e.g.:
> 
>         if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP) ^
>             IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE))
>                 return IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE);
>         else
>                 ...
> 

I think that would only be easier to read for the compiler, not for
for a human. ;-)

	Arnd
