Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3IEQwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:52:17 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51975 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3IEQwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:52:16 -0400
X-IronPort-AV: E=Sophos;i="4.90,848,1371081600"; 
   d="scan'208";a="48569719"
Date: Thu, 5 Sep 2013 17:50:45 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v5 12/13] swiotlb-xen: use
 xen_alloc/free_coherent_pages
In-Reply-To: <20130830135333.GL21239@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1309051743450.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com> <1377801154-29215-12-git-send-email-stefano.stabellini@eu.citrix.com> <20130830135333.GL21239@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Aug 2013, Konrad Rzeszutek Wilk wrote:
> On Thu, Aug 29, 2013 at 07:32:33PM +0100, Stefano Stabellini wrote:
> > Use xen_alloc_coherent_pages and xen_free_coherent_pages to allocate or
> > free coherent pages.
> > 
> > We need to be careful handling the pointer returned by
> > xen_alloc_coherent_pages, because on ARM the pointer is not equal to
> > phys_to_virt(*dma_handle). In fact virt_to_phys on the returned pointer
> > doesn't return a valid physical address.
> 
> Why is it called 'virt_to_phys'? What does it return then?

virt_to_phys only works for kernel direct mapped RAM memory.
In this case the virtual address could be an ioremap address, therefore
passing it to virt_to_phys would give you another physical address that
doesn't correspond to it.
