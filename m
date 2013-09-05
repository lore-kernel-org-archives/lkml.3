Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3IERAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:00:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10441 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab3IERAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:00:11 -0400
X-IronPort-AV: E=Sophos;i="4.90,848,1371081600"; 
   d="scan'208";a="50925284"
Date: Thu, 5 Sep 2013 17:59:52 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 05/13] xen/arm,arm64: move Xen initialization
 earlier
In-Reply-To: <20130905162026.GJ11887@arm.com>
Message-ID: <alpine.DEB.2.02.1309051755560.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com> <1377801154-29215-5-git-send-email-stefano.stabellini@eu.citrix.com> <20130905162026.GJ11887@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013, Catalin Marinas wrote:
> On Thu, Aug 29, 2013 at 07:32:26PM +0100, Stefano Stabellini wrote:
> > Move Xen initialization earlier, before any DMA requests can be made.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> I guess you should cc the corresponding maintainers here.

Thanks for the reminder, I'll do that.


> >  arch/arm/include/asm/xen/hypervisor.h |    8 ++++++++
> >  arch/arm/kernel/setup.c               |    2 ++
> >  arch/arm/xen/enlighten.c              |   21 ++++++++++++++-------
> >  arch/arm64/kernel/setup.c             |    2 ++
> >  4 files changed, 26 insertions(+), 7 deletions(-)
> 
> [...]
> 
> > --- a/arch/arm64/kernel/setup.c
> > +++ b/arch/arm64/kernel/setup.c
> > @@ -53,6 +53,7 @@
> >  #include <asm/traps.h>
> >  #include <asm/memblock.h>
> >  #include <asm/psci.h>
> > +#include <asm/xen/hypervisor.h>
> >  
> >  unsigned int processor_id;
> >  EXPORT_SYMBOL(processor_id);
> > @@ -267,6 +268,7 @@ void __init setup_arch(char **cmdline_p)
> >  	unflatten_device_tree();
> >  
> >  	psci_init();
> > +	xen_early_init();
> 
> So Xen guests don't have any hope for single Image? Basically you set
> dma_ops unconditionally in xen_early_init(), even if the kernel is not
> intended to run under Xen.

That should not happen: if we are not running on Xen xen_early_init
returns early, before calling xen_mm_init.
