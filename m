Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaIOI1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:27:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbaIOI1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:27:50 -0400
Date: Mon, 15 Sep 2014 09:36:37 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/3] PCI/MSI/Armada-370-xp: Remove
 arch_msi_check_device()
Message-ID: <20140915083636.GD8793@agordeev.usersys.redhat.com>
References: <cover.1410078503.git.agordeev@redhat.com>
 <9f3497a0f478f3ee7d4a16b9a4221d4377e5863d.1410078503.git.agordeev@redhat.com>
 <20140908111656.GC30828@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908111656.GC30828@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 07:16:56AM -0400, Jason Cooper wrote:
> + free-electron's guys.

Hi Gentlemen,

Any feedback on this patch?

Thanks!

> On Sun, Sep 07, 2014 at 08:57:54PM +0200, Alexander Gordeev wrote:
> > Moving MSI checks from arch_msi_check_device() function to
> > arch_setup_msi_irqs() function makes code more compact and
> > allows removing unnecessary hook arch_msi_check_device()
> > from generic MSI code.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: linux-pci@vger.kernel.org
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > ---
> >  drivers/irqchip/irq-armada-370-xp.c | 14 ++++----------
> >  1 file changed, 4 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
> > index 574aba0..df60eab 100644
> > --- a/drivers/irqchip/irq-armada-370-xp.c
> > +++ b/drivers/irqchip/irq-armada-370-xp.c
> > @@ -136,6 +136,10 @@ static int armada_370_xp_setup_msi_irq(struct msi_chip *chip,
> >  	struct msi_msg msg;
> >  	int virq, hwirq;
> >  
> > +	/* We support MSI, but not MSI-X */
> > +	if (desc->msi_attrib.is_msix)
> > +		return -EINVAL;
> > +
> >  	hwirq = armada_370_xp_alloc_msi();
> >  	if (hwirq < 0)
> >  		return hwirq;
> > @@ -166,15 +170,6 @@ static void armada_370_xp_teardown_msi_irq(struct msi_chip *chip,
> >  	armada_370_xp_free_msi(hwirq);
> >  }
> >  
> > -static int armada_370_xp_check_msi_device(struct msi_chip *chip, struct pci_dev *dev,
> > -					  int nvec, int type)
> > -{
> > -	/* We support MSI, but not MSI-X */
> > -	if (type == PCI_CAP_ID_MSI)
> > -		return 0;
> > -	return -EINVAL;
> > -}
> > -
> >  static struct irq_chip armada_370_xp_msi_irq_chip = {
> >  	.name = "armada_370_xp_msi_irq",
> >  	.irq_enable = unmask_msi_irq,
> > @@ -213,7 +208,6 @@ static int armada_370_xp_msi_init(struct device_node *node,
> >  
> >  	msi_chip->setup_irq = armada_370_xp_setup_msi_irq;
> >  	msi_chip->teardown_irq = armada_370_xp_teardown_msi_irq;
> > -	msi_chip->check_device = armada_370_xp_check_msi_device;
> >  	msi_chip->of_node = node;
> >  
> >  	armada_370_xp_msi_domain =
> > -- 
> > 1.9.3
> > 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
