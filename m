Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbaCDOM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:12:57 -0500
Received: from 8bytes.org ([85.214.48.195]:58329 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbaCDOM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:12:56 -0500
Date: Tue, 4 Mar 2014 15:12:51 +0100
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Jay Cornwall <jay.cornwall@amd.com>
Subject: Re: [PATCH 1/1] iommu/amd: Fix PASID format in
 INVALIDATE_IOTLB_PAGES command
Message-ID: <20140304141251.GB2799@8bytes.org>
References: <1393451371-17894-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393451371-17894-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar  4 15:12:54 2014
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5315df6620862061481397
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 03:49:31PM -0600, suravee.suthikulpanit@amd.com wrote:
> From: Jay Cornwall <jay.cornwall@amd.com>
> 
> This patch corrects the PASID format in the INVALIDATE_IOTLB_PAGES
> command, which was caused by incorrect information in
> the AMD IOMMU Architectural Specification v2.01 document.
> 
>     Incorrect format:
>          cmd->data[0][16:23] = PASID[7:0]
>          cmd->data[1][16:27] = PASID[19:8]
> 
>      Correct format:
>          cmd->data[0][16:23] = PASID[15:8]
>          cmd->data[1][16:23] = PASID[7:0]
> 
> However, this does not affect the IOMMUv2 hardware implementation,
> and has been corrected since version 2.02 of the specification
> (available through AMD NDA).
> 
> Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Applied, thanks.

Does this mean that PASIDs are only 16 bits wide now from the former 20
bits?


