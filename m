Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaKGOMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:12:32 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:59247 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaKGOML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:12:11 -0500
X-IronPort-AV: E=Sophos;i="5.07,332,1413244800"; 
   d="scan'208";a="190564560"
Date: Fri, 7 Nov 2014 14:10:34 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
In-Reply-To: <20141107111126.GB21875@localhost>
Message-ID: <alpine.DEB.2.02.1411071239110.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com> <20141103105716.GC23162@arm.com>
 <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com> <20141105165646.GN32700@e104818-lin.cambridge.arm.com> <alpine.DEB.2.02.1411051757140.22875@kaball.uk.xensource.com> <20141106103337.GA19702@e104818-lin.cambridge.arm.com>
 <alpine.DEB.2.02.1411061155200.22875@kaball.uk.xensource.com> <20141107110524.GA21875@localhost> <20141107111126.GB21875@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014, Catalin Marinas wrote:
> On Fri, Nov 07, 2014 at 11:05:25AM +0000, Catalin Marinas wrote:
> > BTW, drivers/xen/swiotlb-xen.c needs something like:
> > 
> >         dma_addr_t dev_addr = xen_phys_to_bus(phys_to_dma(phys));
> > 
> > phys != bus address.
> 
> Wrong place, what I meant is when calling:
> 
>         xen_dma_unmap_page(hwdev, phys_to_dma(paddr), size, dir, attrs);

Well spotted! This is an actual mistake in the current code, independent
from the problem described before. Julien reported it a couple of days
ago and I have already queued a patch to fix it at the end of the
series.
