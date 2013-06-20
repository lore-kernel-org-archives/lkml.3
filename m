Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030347Ab3FTPWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:22:54 -0400
Received: from 8bytes.org ([85.214.48.195]:35324 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030331Ab3FTPWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:22:52 -0400
Date: Thu, 20 Jun 2013 17:22:48 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: amd/intel: Remove multifunction assumption around
 grouping
Message-ID: <20130620152248.GF3589@8bytes.org>
References: <20130530183855.14612.15585.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530183855.14612.15585.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 17:22:50 2013
X-DSPAM-Confidence: 0.9983
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c31e4a20862151317104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 12:39:18PM -0600, Alex Williamson wrote:
> If a device is multifunction and does not have ACS enabled then we
> assume that the entire package lacks ACS and use function 0 as the
> base of the group.  The PCIe spec however states that components are
> permitted to implement ACS on some, none, or all of their applicable
> functions.  It's therefore conceivable that function 0 may be fully
> independent and support ACS while other functions do not.  Instead
> use the lowest function of the slot that does not have ACS enabled
> as the base of the group.  This may be the current device, which is
> intentional.  So long as we use a consistent algorithm, all the
> non-ACS functions will be grouped together and ACS functions will
> get separate groups.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/iommu/amd_iommu.c   |   25 +++++++++++++++++++------
>  drivers/iommu/intel-iommu.c |   25 +++++++++++++++++++------

Didn't really fit into any of my existing branches. Applied it to
x86/vt-d because it is probably not worth creating a new x86-specific
branch just for this patch.

Thanks,

	Joerg


