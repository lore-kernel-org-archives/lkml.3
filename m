Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3H2Pib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:38:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20827 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3H2Pia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:38:30 -0400
X-IronPort-AV: E=Sophos;i="4.89,984,1367971200"; 
   d="scan'208";a="46460208"
Date: Thu, 29 Aug 2013 16:38:17 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 10/10] xen/arm,arm64: enable SWIOTLB_XEN
In-Reply-To: <1377765650.11455.7.camel@kazak.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1308291637230.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>   <1376565054-24153-10-git-send-email-stefano.stabellini@eu.citrix.com>  <1376600325.9273.223.camel@hastur.hellion.org.uk>  <alpine.DEB.2.02.1308282104000.6397@kaball.uk.xensource.com>
 <1377765650.11455.7.camel@kazak.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Ian Campbell wrote:
> On Wed, 2013-08-28 at 21:07 +0100, Stefano Stabellini wrote:
> > On Thu, 15 Aug 2013, Ian Campbell wrote:
> > > On Thu, 2013-08-15 at 12:10 +0100, Stefano Stabellini wrote:
> > > > At the moment always rely on swiotlb-xen, but when Xen starts supporting
> > > > hardware IOMMUs we'll be able to avoid it conditionally on the presence
> > > > of an IOMMU on the platform.
> > > 
> > > Do we have any idea how we are going to do this?
> > > 
> > > It's extra complicated if you consider that on some systems on some of
> > > the devices are behind an IOMMU :-/
> > > 
> > > I wonder if we can enumerate which devices have an IOMMU at boot time
> > > and force a ludicrous dma mask (such as 0) if one isn't present in order
> > > to force us to always take the exchange_and_pin path?
> > 
> > We don't need to worry about how to specify which devices need to go via
> > the swiotlb internally, because we have our own arm specific
> > dma_map_ops. At the moment they are just implemented using the
> > swiotlb-xen functions, but we could easily provide wrappers that check
> > our own internal whitelist/blacklist and go via swiotlb-xen only in
> > those cases.
> 
> OK, but how do we decide which devices go on those lists? We need some
> sort of indication from the hypervisor, don't we? Only Xen knows if it
> has an iommu it can use because the iommu must necessarily be hidden
> from Linux.

Right. Maybe Xen could mark the devices that are safe to use without
swiotlb-xen on device tree? Adding a property to the node?
