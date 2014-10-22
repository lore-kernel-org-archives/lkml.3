Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaJVO3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:29:25 -0400
Received: from 8bytes.org ([81.169.241.247]:36637 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaJVO3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:29:24 -0400
Date: Wed, 22 Oct 2014 16:29:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu: Implement a dummy bus_set_iommu()
Message-ID: <20141022142922.GH10074@8bytes.org>
References: <1406897113-20099-1-git-send-email-thierry.reding@gmail.com>
 <1406897113-20099-2-git-send-email-thierry.reding@gmail.com>
 <20140818165750.GE9809@8bytes.org>
 <20141015091043.GA13162@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015091043.GA13162@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 11:10:44AM +0200, Thierry Reding wrote:
> It seems like I never got back to you on this. The reason here is that
> for Tegra the IOMMU is part of a larger IP block. The IP block is
> primarily a memory controller with a bunch of configuration knobs for
> arbitration, prioritization and whatnot. A smaller part of the device
> does the IOMMU translation. Therefore the IOMMU implementation would
> be part of a larger driver, and having this dummy would reduce the
> amount of #ifdefs required.
> 
> bus_set_iommu() is also the only function in include/linux/iommu.h that
> doesn't have a dummy, so it seemed like a natural thing to do.
> 
> That said, I can work around this being absent for !IOMMU_API.

Or you make this "larger driver" just depend on IOMMU_API? Otherwise you
need the #ifdefs anyway to not carry around the iommu-ops functions in
the driver without having the iommu core enabled, no?


	Joerg

