Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbbANRks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:40:48 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40134 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752782AbbANRkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:40:45 -0500
Date: Wed, 14 Jan 2015 17:40:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vitaly Andrianov <vitalya@ti.com>
Cc: thomas.petazzoni@free-electrons.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: use phys_addr_t in __arm_ioremap functions
Message-ID: <20150114174035.GA12302@n2100.arm.linux.org.uk>
References: <1421256154-18514-1-git-send-email-vitalya@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421256154-18514-1-git-send-email-vitalya@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 12:22:34PM -0500, Vitaly Andrianov wrote:
> On a 32 bit ARM architecture with LPAE extension physical addresses
> cannot fit into unsigned long variable.
> 
> This patch fixes the ioremap_page, __map_ioremap_pfn_caller,
> __arm_ioremap and __arm_ioremap_exec functions.

This patch does not do what the description says.  It only touches one
function - ioremap_page(), which from what I can see is never called.

It looks like it was introduced by Hiroshi DOYU without coming through
my core ARM tree (was it even reviewed?) in 2009, but six years on, it
doesn't have any users:

$ git grep 'ioremap_page\>'
arch/arm/include/asm/mach/map.h:extern int ioremap_page(unsigned long virt, unsi...
arch/arm/mm/ioremap.c:int ioremap_page(unsigned long virt, unsigned long phys,
arch/arm/mm/ioremap.c:EXPORT_SYMBOL(ioremap_page);
arch/unicore32/mm/ioremap.c:int ioremap_page(unsigned long virt, unsigned long p...
arch/unicore32/mm/ioremap.c:EXPORT_SYMBOL(ioremap_page);

I'd much rather see a patch deleting ioremap_page().

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
