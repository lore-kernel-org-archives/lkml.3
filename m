Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab3IEQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:09:56 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51641 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752927Ab3IEQJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:09:54 -0400
Date: Thu, 5 Sep 2013 17:09:05 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 11/13] xen: introduce xen_alloc/free_coherent_pages
Message-ID: <20130905160905.GI11887@arm.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
 <1377801154-29215-11-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377801154-29215-11-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 07:32:32PM +0100, Stefano Stabellini wrote:
> xen_swiotlb_alloc_coherent needs to allocate a coherent buffer for cpu
> and devices. On native x86 and ARMv8 is sufficient to call
> __get_free_pages in order to get a coherent buffer, while on ARM we need
> to call arm_dma_ops.alloc.

Don't bet on this for ARMv8. It's not mandated for the architecture, so
at some point some SoC will require non-cacheable buffers for coherency.

-- 
Catalin
