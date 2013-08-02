Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3HBMOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:14:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33749 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3HBMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:14:29 -0400
Date: Fri, 2 Aug 2013 08:13:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH RFC 1/8] arm: make SWIOTLB available
Message-ID: <20130802121340.GH24540@konrad-lan.dumpdata.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com>
 <1375292732-7627-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <334c4fe7-e40c-489c-84db-9bb58c705d44@email.android.com>
 <alpine.DEB.2.02.1308021250050.4893@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308021250050.4893@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 12:59:00PM +0100, Stefano Stabellini wrote:
> On Wed, 31 Jul 2013, Konrad Rzeszutek Wilk wrote:
> > Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > >Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > >CC: will.deacon@arm.com
> > >CC: linux@arm.linux.org.uk
> > >---
> > > arch/arm/Kconfig                   |    7 +++++++
> > > arch/arm/include/asm/dma-mapping.h |   24 ++++++++++++++++++++++++
> > > 2 files changed, 31 insertions(+), 0 deletions(-)
> > >
> > >diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > >index ba412e0..05125ab 100644
> > >--- a/arch/arm/Kconfig
> > >+++ b/arch/arm/Kconfig
> > >@@ -1832,6 +1832,13 @@ config CC_STACKPROTECTOR
> > > 	  neutralized via a kernel panic.
> > > 	  This feature requires gcc version 4.2 or above.
> > > 
> > >+config SWIOTLB
> > >+	def_bool y
> > >+	select NEED_SG_DMA_LENGTH
> > >+
> > >+config IOMMU_HELPER
> > >+	def_bool SWIOTLB
> > >+
> > 
> > Could you explain the purpose of these two a bit more please? 
> 
> SWIOTLB is not available on arm at the moment.
> We need to make it available, otherwise SWIOTLB_XEN won't be able to
> select it.
> 
> Similarly, IOMMU_HELPER is another lib Kconfig symbol needed by SWIOTLB
> to compile.

I was more curious about the NEED_SG_DMA_LENGTH and IOMMU_HELPER.
I think the NEED_SG_DMA_LENGTH is optional? Or does SWIOTLB complain
about? I do recall seeing a patch for this at some point but it was
malformed. It was just changing SWIOTLB to use a macro for
sg->dma_length or such.

But the IOMMU_HELPER? That seems odds as the DMA API (which as you know
is what SWIOTLB hooks up to) is _below_ the IOMMU API.  Ah, it is 
'iommu_is_span_boundary' function.  Gotcha.

Could you mention that in the git commit please? Just say that SWIOTLB
uses some of the common code that IOMMU API uses - which is in the
lib/iommu_helper.c hence the need for that.

And for the NEED_SG_DMA_LENGTH let me dig up the patch at some point and
send it your way so you can make it part of this series.


