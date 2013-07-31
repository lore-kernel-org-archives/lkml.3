Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab3GaUBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:01:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39441 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3GaUBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:01:49 -0400
Date: Wed, 31 Jul 2013 21:01:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, konrad.wilk@oracle.com,
        Ian.Campbell@citrix.com, will.deacon@arm.com
Subject: Re: [PATCH v2 RFC 2/8] arm: introduce a global dma_ops pointer
Message-ID: <20130731200135.GZ24642@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1307312048511.4893@kaball.uk.xensource.com> <1375300452-12545-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375300452-12545-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 08:54:06PM +0100, Stefano Stabellini wrote:
> Initially set dma_ops to arm_dma_ops.
> Use dma_ops instead of arm_dma_ops in dmabounce.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: will.deacon@arm.com
> CC: linux@arm.linux.org.uk

If you're using swiotlb, there's little point in converting dmabounce
to be able to use it, because it's basically providing the same
functionality - dmabounce is there to do software buffer bouncing within
the DMA to move streaming buffers from DMA-inaccessible memory into
DMA-accessible memory.

It's original use is with older SoCs with buggy DMA (eg, those which
can only address alternate 1MB chunks of memory for example) but also
got used in situations where alternative solutions would've been better
(like using swiotlb.)  I've been discouraging its use as it's suffered
from memory exhaustion problems (there's a number of threads and bug
reports which were never solved about IXP4xx(?) platforms suffering
this due to this bouncing.)
