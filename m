Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab3CZPDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:03:18 -0400
Received: from 8bytes.org ([85.214.48.195]:45316 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933659Ab3CZPDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:03:14 -0400
Date: Tue, 26 Mar 2013 16:03:10 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: lizhenhua@hp.com, Ingo Molnar <mingo@kernel.org>,
        Donald Dutile <ddutile@redhat.com>, Hannes Reinecke <hare@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu: dmar_fault should only clear PPF/PFO field.
Message-ID: <20130326150305.GC2727@8bytes.org>
References: <1364199652-10090-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364199652-10090-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar 26 16:03:13 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5151b8b123679701810512
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 04:20:52PM +0800, Li, Zhen-Hua wrote:
> +	writel(DMA_FSTS_PPF, iommu->reg + DMAR_FSTS_REG);
> +	if (fault_status & DMA_FSTS_PFO)
> +		writel(DMA_FSTS_PFO, iommu->reg + DMAR_FSTS_REG);

Changes this to:

	writel(DMA_FSTS_PFO | DMA_FSTS_PPF, iommu->reg + DMAR_FSTS_REG);

and applied the patch to iommu/vt-d, thanks.


	Joerg


