Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab3EBKyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:54:25 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:53052 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab3EBKyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:54:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,595,1363132800"; 
   d="scan'208";a="21770145"
Date: Thu, 2 May 2013 11:54:16 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/arm: account for stolen ticks
In-Reply-To: <1367491708.21869.77.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1305021153220.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>  <1367436460-10183-3-git-send-email-stefano.stabellini@eu.citrix.com>  <1367482862.21869.28.camel@zakaz.uk.xensource.com>  <alpine.DEB.2.02.1305021134160.5398@kaball.uk.xensource.com>
 <1367491708.21869.77.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Ian Campbell wrote:
> On Thu, 2013-05-02 at 11:38 +0100, Stefano Stabellini wrote:
> > On Thu, 2 May 2013, Ian Campbell wrote:
> > > On Wed, 2013-05-01 at 20:27 +0100, Stefano Stabellini wrote:
> > > > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > > > index d30042e..8f040a0 100644
> > > > --- a/arch/arm/xen/enlighten.c
> > > > +++ b/arch/arm/xen/enlighten.c
> > > > @@ -14,6 +14,7 @@
> > > >  #include <xen/xen-ops.h>
> > > >  #include <asm/xen/hypervisor.h>
> > > >  #include <asm/xen/hypercall.h>
> > > > +#include <asm/arch_timer.h>
> > > >  #include <asm/system_misc.h>
> > > >  #include <linux/interrupt.h>
> > > >  #include <linux/irqreturn.h>
> > > > @@ -172,6 +173,8 @@ static int __init xen_secondary_init(unsigned int cpu)
> > > >  		   later ones fail to. */
> > > >  		per_cpu(xen_vcpu, cpu) = vcpup;
> > > >  	}
> > > > +
> > > > +	xen_setup_runstate_info(cpu);
> > > 
> > > Is this called for the boot processor too?
> > 
> > Yep.
> > 
> > > (do you have a linux-next branch where I can easily find the baseline
> > > for this series?)
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git lost_ticks_1
> 
> Is that your Xen tree, I was after the Linux one...

nope, that's my Linux tree disguised as a Xen tree to confuse the
maintainers ;-)

> > It's based on my 3.9-rc3-smp-6 branch currently in linux-next (that is
> > based on 3.9-rc3).
> > However lost_ticks_1 is not in linux-next yet.
> 
> Which branch is in Linux next? It doesn't seem to be your linux-next
> (last commit 2011).

that would be linux-next from
git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git
