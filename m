Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaIDKOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:14:07 -0400
Received: from 8bytes.org ([81.169.241.247]:57312 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbaIDKOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:14:04 -0400
Date: Thu, 4 Sep 2014 12:14:02 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        Emilian.Medve@freescale.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/fsl: Fix warning resulting from adding PCI device
 twice
Message-ID: <20140904101402.GM28786@8bytes.org>
References: <1409810622-742-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409810622-742-1-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:33:42AM +0530, Varun Sethi wrote:
> +	if (!iommu_group_get(dev))
> +		ret = iommu_group_add_device(group, dev);
>  
>  	iommu_group_put(group);
>  	return ret;

Doesn't this additional call to iommu_group_get take a reference to the
iommu_group that needs to be released?


	Joerg

