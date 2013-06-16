Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3FPJOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 05:14:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42945 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3FPJOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 05:14:01 -0400
Date: Sun, 16 Jun 2013 10:10:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@linaro.org>
Cc: Nicolas Pitre <nico@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC] arm: Remove sa1111 special case from mm setup code
Message-ID: <20130616091005.GP18614@n2100.arm.linux.org.uk>
References: <1371338108-26354-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371338108-26354-1-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 12:15:08AM +0100, Grant Likely wrote:
> I don't think this special case is needed anymore. From what I can tell,
> setup_dma_zone() takes care of marking the region to be reserved for
> DMA, and that happens before arm_memblock_init() which calls
> arm_mm_memblock_reserve(). Therefore the mm setup should already know
> about the reserved region and it won't need to be explicitly reserved
> and then freed. That means the special case can be dropped from the
> common code.

No it doesn't.  setup_dma_zone is all about setting the high watermark
for GFP_DMA allocations.  It has nothing to do with _temoprarily_
reserving the low 1MB, ensuring that no other user can use any of that
precious SA1111 memory during the kernel boot.
