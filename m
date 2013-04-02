Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3DBPKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:10:20 -0400
Received: from 8bytes.org ([85.214.48.195]:53874 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574Ab3DBPKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:10:15 -0400
Date: Tue, 2 Apr 2013 17:10:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: stuart.yoder@freescale.com, scottwood@freescale.com,
        iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        benh@kernel.crashing.org
Subject: Re: [PATCH 4/5 v11] iommu/fsl: Add additional iommu attributes
 required by the PAMU driver.
Message-ID: <20130402151011.GH15687@8bytes.org>
References: <1364500442-20927-1-git-send-email-Varun.Sethi@freescale.com>
 <1364500442-20927-5-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364500442-20927-5-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 17:10:14 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515af4d623672050420500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 01:24:01AM +0530, Varun Sethi wrote:
> +/* cache stash targets */
> +enum stash_target {
> +	IOMMU_ATTR_CACHE_L1 = 1,
> +	IOMMU_ATTR_CACHE_L2,
> +	IOMMU_ATTR_CACHE_L3,
> +};
> +
> +/* This attribute corresponds to IOMMUs capable of generating
> + * a stash transaction. A stash transaction is typically a
> + * hardware initiated prefetch of data from memory to cache.
> + * This attribute allows configuring stashig specific parameters
> + * in the IOMMU hardware.
> + */
> +
> +struct iommu_stash_attribute {
> +	u32 	cpu;	/* cpu number */
> +	u32 	cache;	/* cache to stash to: L1,L2,L3 */
> +};
> +

I would prefer these PAMU specific enum and struct to be in a
pamu-specific iommu-header.


	Joerg


