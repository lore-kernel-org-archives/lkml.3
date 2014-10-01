Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaJANxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:53:05 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50016 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751610AbaJANxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:53:00 -0400
Date: Wed, 1 Oct 2014 14:52:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Sean Paul <seanpaul@chromium.org>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ritesh.harjani@gmail.com" <ritesh.harjani@gmail.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Use and error-check DMA_ERROR_CODE
Message-ID: <20141001135248.GQ5182@n2100.arm.linux.org.uk>
References: <1412108121-19262-1-git-send-email-seanpaul@chromium.org> <20141001101323.GB2587@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001101323.GB2587@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 11:13:23AM +0100, Will Deacon wrote:
> Hi Sean,
> 
> On Tue, Sep 30, 2014 at 09:15:21PM +0100, Sean Paul wrote:
> > +
> > +	if (dma_handle != DMA_ERROR_CODE)
> > +		__dma_free_coherent(dev, size, swiotlb_addr, dma_handle, attrs);
> 
> Is it legal to try and free a DMA buffer after a failed allocation? If so, I
> think we need something similar for arch/arm/.

No.

	void
	dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
	                           dma_addr_t dma_handle)

	Free a region of consistent memory you previously allocated.  dev,
	                                       ^^^^^^^^^^^^^^^^^^^^^
This implies that the allocation was successful.

	size and dma_handle must all be the same as those passed into
	dma_alloc_coherent().  cpu_addr must be the virtual address returned by
	                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you want this behaviour, the proper way to do it would be to check
for a NULL cpu_addr, just like kfree() etc.

	the dma_alloc_coherent().

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
