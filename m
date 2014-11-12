Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaKLJnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:43:49 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57594 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752554AbaKLJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:43:46 -0500
Date: Wed, 12 Nov 2014 10:43:42 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Kevin Cernekee <cernekee@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Kevin Hilman <khilman@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-sh@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        linux-mips@linux-mips.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] irqchip: atmel-aic: fix irqdomain initialization
Message-ID: <20141112104342.3d28ad46@bbrezillon>
In-Reply-To: <20141111225800.GE3698@titan.lakedaemon.net>
References: <20141110230301.GV4068@piout.net>
	<1415712816-9202-1-git-send-email-boris.brezillon@free-electrons.com>
	<20141111225800.GE3698@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Tue, 11 Nov 2014 17:58:00 -0500
Jason Cooper <jason@lakedaemon.net> wrote:

> On Tue, Nov 11, 2014 at 02:33:36PM +0100, Boris Brezillon wrote:
> > First of all IRQCHIP_SKIP_SET_WAKE is not a valid irq_gc_flags and thus
> > should not be passed as the last argument of
> > irq_alloc_domain_generic_chips.
> > 
> > Then pass the correct handler (handle_fasteoi_irq) to
> > irq_alloc_domain_generic_chips instead of manually re-setting it in the
> > initialization loop.
> > 
> > And eventually initialize default irq flags to the pseudo standard:
> > IRQ_REQUEST | IRQ_PROBE | IRQ_AUTOEN.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> > Hello Kevin,
> > 
> > This patch has not been tested yet but it should solve the issue you've
> > experienced with the IRQ_GC_BE_IO flag and the atmel-aic driver.
> > 
> > I'll test it tomorrow and let you know if it actually works.

Tested it, and it seems to work.

> > 
> > Regards,
> > 
> > Boris
> > 
> >  drivers/irqchip/irq-atmel-aic-common.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Applied to irqchip/urgent with Kevin's Tested-by.  Also, flagged for
> stable, v3.17 and up.

Thanks!

> 
> Boris, once this is in mainline, you may want to generate a patch
> against older versions (in the arch dir) for the stable team.

Actually, the old irq driver does not use the generic irqchip
infrastructure and thus is not impacted by this bug.

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
