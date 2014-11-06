Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaKFWv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:51:56 -0500
Received: from 8bytes.org ([81.169.241.247]:53674 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbaKFWvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:51:52 -0500
Date: Thu, 6 Nov 2014 23:51:50 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/amd: Use delayed mmu release notifier
Message-ID: <20141106225150.GT10744@8bytes.org>
References: <54418D7F.3050304@amd.com>
 <20141106133354.GP10744@8bytes.org>
 <545B7C43.4020106@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B7C43.4020106@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 03:48:51PM +0200, Oded Gabbay wrote:
> What do you mean ? I don't see I change anything in the API. All the
> changes are internal to amd_iommu_unbind_pasid(). I don't think
> *anyone* calling to amd_iommu_unbind_pasid() will care or will
> notice the slight change in timing of releasing the pasid_state
> object (instead of immediate release, it is released after the
> iteration on the mmu_notifier list has finished)

The API change is that this patch modifies amd_iommu_unbind_pasid() so
that it could be called from an mmu_notifier_release call-back (which is
not possible right now). It does that by adding just another layer of
call-backs and complicates the code. I'd like to keep that outside of
the IOMMUv2 driver.


	Joerg

