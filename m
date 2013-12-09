Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab3LIQvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:51:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:17908 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab3LIQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:51:00 -0500
X-IronPort-AV: E=Sophos;i="4.93,859,1378857600"; 
   d="scan'208";a="80081945"
Message-ID: <1386607857.7812.66.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] xen/arm64: do not call the swiotlb functions twice
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <catalin.marinas@arm.com>, <Will.Deacon@arm.com>
Date: Mon, 9 Dec 2013 16:50:57 +0000
In-Reply-To: <1386605160-3185-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1386605160-3185-1-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 16:06 +0000, Stefano Stabellini wrote:
> On arm64 the dma_map_ops implementation is based on the swiotlb.
> swiotlb-xen, used by default in dom0 on Xen, is also based on the
> swiotlb.
> 
> Avoid calling into the default arm64 dma_map_ops functions from
> xen_dma_map_page, xen_dma_unmap_page, xen_dma_sync_single_for_cpu, and
> xen_dma_sync_single_for_device otherwise we end up calling into the
> swiotlb twice.
> 
> When arm64 gets a non-swiotlb based implementation of dma_map_ops, we'll
> probably have to reintroduce dma_map_ops calls in page-coherent.h.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: catalin.marinas@arm.com
> CC: Will.Deacon@arm.com

Tested-by: Ian Campbell <ian.campbell@citrix.com>

Ian.


