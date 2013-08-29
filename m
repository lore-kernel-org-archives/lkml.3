Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3H2IlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:41:15 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:35524 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3H2IlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:41:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,981,1367971200"; 
   d="scan'208";a="8215205"
Message-ID: <1377765650.11455.7.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH v4 10/10] xen/arm,arm64: enable SWIOTLB_XEN
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>
Date: Thu, 29 Aug 2013 09:40:50 +0100
In-Reply-To: <alpine.DEB.2.02.1308282104000.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
	  <1376565054-24153-10-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1376600325.9273.223.camel@hastur.hellion.org.uk>
	 <alpine.DEB.2.02.1308282104000.6397@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 21:07 +0100, Stefano Stabellini wrote:
> On Thu, 15 Aug 2013, Ian Campbell wrote:
> > On Thu, 2013-08-15 at 12:10 +0100, Stefano Stabellini wrote:
> > > At the moment always rely on swiotlb-xen, but when Xen starts supporting
> > > hardware IOMMUs we'll be able to avoid it conditionally on the presence
> > > of an IOMMU on the platform.
> > 
> > Do we have any idea how we are going to do this?
> > 
> > It's extra complicated if you consider that on some systems on some of
> > the devices are behind an IOMMU :-/
> > 
> > I wonder if we can enumerate which devices have an IOMMU at boot time
> > and force a ludicrous dma mask (such as 0) if one isn't present in order
> > to force us to always take the exchange_and_pin path?
> 
> We don't need to worry about how to specify which devices need to go via
> the swiotlb internally, because we have our own arm specific
> dma_map_ops. At the moment they are just implemented using the
> swiotlb-xen functions, but we could easily provide wrappers that check
> our own internal whitelist/blacklist and go via swiotlb-xen only in
> those cases.

OK, but how do we decide which devices go on those lists? We need some
sort of indication from the hypervisor, don't we? Only Xen knows if it
has an iommu it can use because the iommu must necessarily be hidden
from Linux.

Ian.

