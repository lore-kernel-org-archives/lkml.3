Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3EBKsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:48:32 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:61542 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab3EBKsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:48:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4153164"
Message-ID: <1367491708.21869.77.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/arm: account for stolen ticks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 2 May 2013 11:48:28 +0100
In-Reply-To: <alpine.DEB.2.02.1305021134160.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
	 <1367436460-10183-3-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1367482862.21869.28.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1305021134160.5398@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 11:38 +0100, Stefano Stabellini wrote:
> On Thu, 2 May 2013, Ian Campbell wrote:
> > On Wed, 2013-05-01 at 20:27 +0100, Stefano Stabellini wrote:
> > > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > > index d30042e..8f040a0 100644
> > > --- a/arch/arm/xen/enlighten.c
> > > +++ b/arch/arm/xen/enlighten.c
> > > @@ -14,6 +14,7 @@
> > >  #include <xen/xen-ops.h>
> > >  #include <asm/xen/hypervisor.h>
> > >  #include <asm/xen/hypercall.h>
> > > +#include <asm/arch_timer.h>
> > >  #include <asm/system_misc.h>
> > >  #include <linux/interrupt.h>
> > >  #include <linux/irqreturn.h>
> > > @@ -172,6 +173,8 @@ static int __init xen_secondary_init(unsigned int cpu)
> > >  		   later ones fail to. */
> > >  		per_cpu(xen_vcpu, cpu) = vcpup;
> > >  	}
> > > +
> > > +	xen_setup_runstate_info(cpu);
> > 
> > Is this called for the boot processor too?
> 
> Yep.
> 
> > (do you have a linux-next branch where I can easily find the baseline
> > for this series?)
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git lost_ticks_1

Is that your Xen tree, I was after the Linux one...

> It's based on my 3.9-rc3-smp-6 branch currently in linux-next (that is
> based on 3.9-rc3).
> However lost_ticks_1 is not in linux-next yet.

Which branch is in Linux next? It doesn't seem to be your linux-next
(last commit 2011).

Ian.

