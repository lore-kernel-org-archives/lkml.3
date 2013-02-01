Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3BANzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:55:02 -0500
Received: from 8bytes.org ([85.214.48.195]:59408 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab3BANzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:55:00 -0500
Date: Fri, 1 Feb 2013 14:54:57 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/4] iommu/shmobile: Add iommu driver for Renesas
 IPMMU modules
Message-ID: <20130201135456.GG25591@8bytes.org>
References: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
 <1358765669-14567-2-git-send-email-hdk@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358765669-14567-2-git-send-email-hdk@igel.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Feb  1 14:54:59 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510bc93322971702590454
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 07:54:26PM +0900, Hideki EIRAKU wrote:
> This is the Renesas IPMMU driver and IOMMU API implementation.
> 
> The IPMMU module supports the MMU function and the PMB function.  The
> MMU function provides address translation by pagetable compatible with
> ARMv6.  The PMB function provides address translation including
> tile-linear translation.  This patch implements the MMU function.
> 
> The iommu driver does not register a platform driver directly because:
> - the register space of the MMU function and the PMB function
>   have a common register (used for settings flush), so they should ideally
>   have a way to appropriately share this register.
> - the MMU function uses the IOMMU API while the PMB function does not.
> - the two functions may be used independently.
> 
> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>

The patch looks good in general. Just one question inline.

> +static int pgtable_alloc(struct shmobile_iommu_domain_pgtable *pgtable,
> +			 struct kmem_cache *cache, size_t size)
> +{
> +	pgtable->pgtable = kmem_cache_zalloc(cache, GFP_ATOMIC);
> +	if (!pgtable->pgtable)
> +		return -ENOMEM;
> +	pgtable->handle = dma_map_single(NULL, pgtable->pgtable, size,
> +					 DMA_TO_DEVICE);
> +	return 0;
> +}

Why is it necessary to call dma_map_single() for IOMMU page-tables?
usually the dma_* functions call into IOMMU drivers, so why are they
used inside an IOMMU driver?

Regards,

	Joerg


