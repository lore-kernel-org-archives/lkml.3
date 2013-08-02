Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab3HBL7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:59:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3HBL7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:59:14 -0400
X-IronPort-AV: E=Sophos;i="4.89,800,1367971200"; 
   d="scan'208";a="39021726"
Date: Fri, 2 Aug 2013 12:59:00 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>,
        <will.deacon@arm.com>, <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC 1/8] arm: make SWIOTLB available
In-Reply-To: <334c4fe7-e40c-489c-84db-9bb58c705d44@email.android.com>
Message-ID: <alpine.DEB.2.02.1308021250050.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-1-git-send-email-stefano.stabellini@eu.citrix.com> <334c4fe7-e40c-489c-84db-9bb58c705d44@email.android.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013, Konrad Rzeszutek Wilk wrote:
> Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> >Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >CC: will.deacon@arm.com
> >CC: linux@arm.linux.org.uk
> >---
> > arch/arm/Kconfig                   |    7 +++++++
> > arch/arm/include/asm/dma-mapping.h |   24 ++++++++++++++++++++++++
> > 2 files changed, 31 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >index ba412e0..05125ab 100644
> >--- a/arch/arm/Kconfig
> >+++ b/arch/arm/Kconfig
> >@@ -1832,6 +1832,13 @@ config CC_STACKPROTECTOR
> > 	  neutralized via a kernel panic.
> > 	  This feature requires gcc version 4.2 or above.
> > 
> >+config SWIOTLB
> >+	def_bool y
> >+	select NEED_SG_DMA_LENGTH
> >+
> >+config IOMMU_HELPER
> >+	def_bool SWIOTLB
> >+
> 
> Could you explain the purpose of these two a bit more please? 

SWIOTLB is not available on arm at the moment.
We need to make it available, otherwise SWIOTLB_XEN won't be able to
select it.

Similarly, IOMMU_HELPER is another lib Kconfig symbol needed by SWIOTLB
to compile.
