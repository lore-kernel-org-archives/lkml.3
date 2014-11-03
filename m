Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaKCL2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:28:25 -0500
Received: from smtp.citrix.com ([66.165.176.89]:63304 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaKCL2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:28:22 -0500
X-IronPort-AV: E=Sophos;i="5.07,307,1413244800"; 
   d="scan'208";a="187472573"
Date: Mon, 3 Nov 2014 11:10:18 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v7 3/8] arm64: introduce is_device_dma_coherent
In-Reply-To: <20141103105716.GC23162@arm.com>
Message-ID: <alpine.DEB.2.02.1411031101400.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410261621200.22875@kaball.uk.xensource.com> <1414422568-19103-3-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1411031045340.22875@kaball.uk.xensource.com> <20141103105716.GC23162@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Will Deacon wrote:
> On Mon, Nov 03, 2014 at 10:46:03AM +0000, Stefano Stabellini wrote:
> > On Mon, 27 Oct 2014, Stefano Stabellini wrote:
> > > Introduce a boolean flag and an accessor function to check whether a
> > > device is dma_coherent. Set the flag from set_arch_dma_coherent_ops.
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > CC: will.deacon@arm.com
> > 
> > Will, Catalin,
> > are you OK with this patch?
> 
> It would be nicer if the dma_coherent flag didn't have to be duplicated by
> each architecture in dev_archdata. Is there any reason not to put it in the
> core code?

Yes, there is a reason for it: if I added a boolean dma_coherent flag in
struct device as Catalin initially suggested, what would be the default
for each architecture? Where would I set it for arch that don't use
device tree? It is not easy.

I thought it would be better to introduce is_device_dma_coherent only on
the architectures where it certainly makes sense to have it. In fact I
checked and arm and arm64 are the only architectures to define
set_arch_dma_coherent_ops at the moment. At that point if
is_device_dma_coherent becomes arch-specific, it makes sense to store
the flag in dev_archdata instead of struct device.
