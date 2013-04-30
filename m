Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710Ab3D3Nyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:54:43 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40292 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760658Ab3D3Nym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:54:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,582,1363132800"; 
   d="scan'208";a="22373098"
Date: Tue, 30 Apr 2013 14:54:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the xen-arm
 tree
In-Reply-To: <20130430091845.27d8de4935bd33ddb4a3e8c0@canb.auug.org.au>
Message-ID: <alpine.DEB.2.02.1304301438330.5398@kaball.uk.xensource.com>
References: <20130429175426.9423279609437a2d746cbb7b@canb.auug.org.au> <20130429082511.GA539@arm.com> <alpine.DEB.2.02.1304291049060.5398@kaball.uk.xensource.com> <20130430091845.27d8de4935bd33ddb4a3e8c0@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Stephen Rothwell wrote:
> Hi Stefano,
> 
> On Mon, 29 Apr 2013 10:50:22 +0100 Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> >
> > On Mon, 29 Apr 2013, Catalin Marinas wrote:
> > > 
> > > On Mon, Apr 29, 2013 at 08:54:26AM +0100, Stephen Rothwell wrote:
> > > > Today's linux-next merge of the arm-soc tree got a conflict in
> > > > arch/arm/mach-virt/platsmp.c between commit fe4bff02886b ("arm: introduce
> > > > psci_smp_ops") from the xen-arm tree and commit c0114709ed85 ("irqchip:
> > > > gic: Perform the gic_secondary_init() call via CPU notifier") from the
> > > > arm-soc tree.
> > > > 
> > > > The former renamed the file (and contents) so I applied the following
> > > > patch and can carry the fix as necessary (no action is required).
> > > > 
> > > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > Date: Mon, 29 Apr 2013 17:52:27 +1000
> > > > Subject: [PATCH] arm: fix for Perform the gic_secondary_init() call via CPU
> > > >  notifier
> > > > 
> > > > due to code movement.
> > > > 
> > > > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > ---
> > > >  arch/arm/kernel/psci_smp.c | 7 -------
> > > >  1 file changed, 7 deletions(-)
> > > > 
> > > > diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
> > > > index 6ef139d..cd9acc7 100644
> > > > --- a/arch/arm/kernel/psci_smp.c
> > > > +++ b/arch/arm/kernel/psci_smp.c
> > > > @@ -14,7 +14,6 @@
> > > >   */
> > > >  
> > > >  #include <linux/init.h>
> > > > -#include <linux/irqchip/arm-gic.h>
> > > >  #include <linux/smp.h>
> > > >  #include <linux/of.h>
> > > >  
> > > > @@ -55,11 +54,6 @@ static int __cpuinit psci_boot_secondary(unsigned int cpu,
> > > >  	return -ENODEV;
> > > >  }
> > > >  
> > > > -static void __cpuinit psci_secondary_init(unsigned int cpu)
> > > > -{
> > > > -	gic_secondary_init(0);
> > > > -}
> > > > -
> > > >  #ifdef CONFIG_HOTPLUG_CPU
> > > >  void __ref psci_cpu_die(unsigned int cpu)
> > > >  {
> > > > @@ -84,7 +78,6 @@ bool __init psci_smp_available(void)
> > > >  }
> > > >  
> > > >  struct smp_operations __initdata psci_smp_ops = {
> > > > -	.smp_secondary_init	= psci_secondary_init,
> > > >  	.smp_boot_secondary	= psci_boot_secondary,
> > > >  	.cpu_die		= psci_cpu_die,
> > > >  };
> > > 
> > > The fix looks fine. Thanks.
> > 
> > Indeed, thanks! I'll add to it to the tree.
> 
> You should not apply that to your tree as you don't have the rest of the
> change from the arm-soc tree.  It needs to be applied to the merge of the
> two trees i.e. when Linus merges the last of the two trees.
> 
> This is why I wrote "no action is required".

I added the patch because it is very small and only affects psci_smp.c,
so it is not a problem for me to carry it in the xen-arm tree.
But I see your point, I'll remove it.

As a side note for the arm-soc maintainers in CC, even though I
proactively added the PSCI and the smp_init patches
(http://marc.info/?l=linux-kernel&m=136716063717467&w=2) to linux-next
to make sure they get enough exposure for this merge window, I would
appreciate if you could pick them up in your tree. I think they should
to Linus via arm-soc.
