Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaKFNd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:33:59 -0500
Received: from 8bytes.org ([81.169.241.247]:49540 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaKFNd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:33:56 -0500
Date: Thu, 6 Nov 2014 14:33:54 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/amd: Use delayed mmu release notifier
Message-ID: <20141106133354.GP10744@8bytes.org>
References: <54418D7F.3050304@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54418D7F.3050304@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 12:43:27AM +0300, Oded Gabbay wrote:
> 3. Later, amdkfd's mmu notifier callback (kfd_process_notifier_release()) gets
>    called and releases more things that are related to the process.
>    In that function, amd_iommu_unbind_pasid() is explicitly called.

Can't you just register a delayed funtion in
kfd_process_notifier_release() and call amd_iommu_unbind_pasid() from
there? I really hate to make that part of the IOMMUv2 driver API,
especially since it is going to be turned into a generic IOMMU-API
extension.

And especially since all these hacks could be avoided if the KFD driver
would just turn down everything on closing the file descriptor.


	Joerg

