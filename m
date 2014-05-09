Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaEITww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:52:52 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49248 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbaEITwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:52:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 4/5] iommu: Use dma_addr_t for IOVA arguments
Date: Fri, 09 May 2014 21:52:08 +0200
Message-ID: <9450765.GaoRYW154J@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140509153226.GA3571@google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com> <1399629530.879.21.camel@i7.infradead.org> <20140509153226.GA3571@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mY7IFMcZXX3YFqmKp2HSeE9Zb2zfRSWtGv1Surix1UY
 EsTfxn1P6o6Gmyc5I9Pp6SjRwaGLc0JeY5Hqz/dk36kWNfLSwo
 qN5IBV4Kf7x1Omz3UcEnJl7HbpAe+aJSHX8OQNe0ZzcTMxLjkL
 jMC8Fh8H5+L5NlrvpU6wVpiQ+wfkeQYr1s5jMsBgfpClJVDjuz
 YF7I3B0IJyl/YK4cup+eXRgdVMY8FZwDN6HXb4NseiEneFszhm
 mIv4TKipv+s19jRhAlFdSZ2eUBi1KNKOaBOU3VRgmlOYL7clS4
 K7Z4qaB3YzPiY0ZYAmBNANwQoQT75UujrSFTTBkGKBM9HCj0UP
 HshEB/NroCDfveH9dWto=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2014 09:32:26 Bjorn Helgaas wrote:
> > There are people who care deeply about the performance of IOMMU API
> > map/unmap. It isn't used *just* for virtual machines any more. See
> > drivers/infiniband/hw/usnic/usnic_uiom.c for example.
> 
> Of course we should care about IOMMU API performance.  We should also
> care about interface consistency, and it seems there's a tradeoff in
> this case.  I said "relatively" because I expect map/unmap to be less
> frequent than read/write operations that use the mapping.  I don't
> know anything about infiniband, so maybe that assumption is false
> there.

In most drivers using the streaming DMA API, every mapping is used
exactly once. Think of network or block drivers: they rarely send
the same data twice to the device, and it usually comes from or
goes to some user space buffer.

	Arnd
