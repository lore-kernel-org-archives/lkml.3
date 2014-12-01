Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaLAQ1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:27:45 -0500
Received: from 8bytes.org ([81.169.241.247]:51484 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbaLAQ1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:27:42 -0500
Date: Mon, 1 Dec 2014 17:27:40 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: Fix an off-by-one bug in __domain_mapping()
Message-ID: <20141201162740.GK3762@8bytes.org>
References: <1416966130-866-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416966130-866-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 09:42:10AM +0800, Jiang Liu wrote:
> There's an off-by-one bug in function __domain_mapping(), which may
> trigger the BUG_ON(nr_pages < lvl_pages) when
> 	(nr_pages + 1) & superpage_mask == 0

What is the superpage_mask?

> The issue was introduced by commit 9051aa0268dc "intel-iommu: Combine
> domain_pfn_mapping() and domain_sg_mapping()", which sets sg_res to
> "nr_pages + 1" to avoid some of the 'sg_res==0' code paths.
> 
> It's safe to remove extra "+1" because sg_res is only used to calculate
> page size now.

>From your description and the (hard to read) code in __domain_mapping I
don't really understand the issue yet. Can you please elaborate on this
issue can be triggered?

Is the BUG_ON the only issue and, if yes, can that be fixed by just
changing the BUG_ON condition?

> 	This issue was introduced in v2.6.31, but intel-iommu.c has
> been moved into drivers/iommu in v3.1. So what's the preferred way
> to deal with stable kernels between v2.6.31 and v3.1?

Just remove the kernel version marker from the stable tag. The stable
kernel maintainers for kernels >3.1 will ask you to backport the patch
or just backport it by themselfes.


	Joerg

