Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070Ab3FTP1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:27:16 -0400
Received: from 8bytes.org ([85.214.48.195]:35349 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030221Ab3FTP1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:27:14 -0400
Date: Thu, 20 Jun 2013 17:27:11 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] iommu: Split iommu_unmaps
Message-ID: <20130620152711.GG3589@8bytes.org>
References: <20130618015642.20826.30187.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618015642.20826.30187.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 17:27:12 2013
X-DSPAM-Confidence: 0.9975
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c31f5020867500744058
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 07:57:34PM -0600, Alex Williamson wrote:
> iommu_map splits requests into pages that the iommu driver reports
> that it can handle.  The iommu_unmap path does not do the same.  This
> can cause problems not only from callers that might expect the same
> behavior as the map path, but even from the failure path of iommu_map,
> should it fail at a point where it has mapped and needs to unwind a
> set of pages that the iommu driver cannot handle directly.  amd_iommu,
> for example, will BUG_ON if asked to unmap a non power of 2 size.
> 
> Fix this by extracting and generalizing the sizing code from the
> iommu_map path and use it for both map and unmap.

Very true, thanks for fixing this.

Applied to the core branch.


