Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaLXGRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:17:01 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42181 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaLXGRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:17:00 -0500
Date: Wed, 24 Dec 2014 08:16:57 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] irqchip: Conexant CX92755 interrupts controller
 driver
Message-ID: <20141224061657.GI2481@sapphire.tkos.co.il>
References: <cover.1419318109.git.baruch@tkos.co.il>
 <7997c913e9f6debc09fd62c788b8ac6bd330d4f3.1419318109.git.baruch@tkos.co.il>
 <16151065.LjzHK8TaOo@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16151065.LjzHK8TaOo@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Dec 23, 2014 at 10:02:18PM +0100, Arnd Bergmann wrote:
> On Tuesday 23 December 2014 09:58:42 Baruch Siach wrote:
> > +static void __exception_irq_entry digicolor_handle_irq(struct pt_regs *regs)
> > +{
> > +       u32 status, hwirq;
> > +
> > +       do {
> > +               status = readl(digicolor_irq_base + IC_INT0STATUS_LO);
> > +               if (status) {
> > +                       hwirq = ffs(status) - 1;
> > +               } else {
> > +                       status = readl(digicolor_irq_base + IC_INT0STATUS_XLO);
> > +                       if (status)
> > +                               hwirq = ffs(status) - 1 + 32;
> > +                       else
> > +                               return;
> > +               }
> > +
> > +               handle_domain_irq(digicolor_irq_domain, hwirq, regs);
> > +       } while (1);
> > +}
> > 
> 
> Have you tried using the generic_irqchip code for this? The hardware
> seems simple enough.

Thanks for the tip. I'll look into converting to GENERIC_IRQ_CHIP for next 
version.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
