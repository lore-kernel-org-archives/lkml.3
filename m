Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaFPPWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:22:06 -0400
Received: from 8bytes.org ([85.214.48.195]:40199 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaFPPWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:22:03 -0400
Date: Mon, 16 Jun 2014 17:21:58 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 04/20] iommu/arm-smmu: add capability
 IOMMU_CAP_INTR_REMAP
Message-ID: <20140616152157.GB31771@8bytes.org>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-5-git-send-email-a.motakis@virtualopensystems.com>
 <20140608103129.GC3279@lvm>
 <20140616145344.GD18986@8bytes.org>
 <20140616151329.GQ16758@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616151329.GQ16758@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jun 16 17:22:01 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 539f0b9920866113268035
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:13:29PM +0100, Will Deacon wrote:
> MSIs look just like memory accesses made by the device, so the SMMU
> will translate them to point at the GIC ITS (doorbell). The ITS then
> has tables to work out how to route the MSI.
> 
> So, if IOMMU_CAP_INTR_REMAP is simply supposed to indicate that the
> SMMU can translate MSIs to point somewhere else, then the ARM SMMU can
> always do it.  If it's supposed to indicate that the actual MSI
> payload can be filtered/routed, then that requires the GIC ITS.
> 
> The part I'm unsure of is how VFIO knows where to map the MSIs to.
> That requires knowledge of the physical and virtual doorbell pages --
> is that discoverable in the API?

VFIO does not care about the actual routing, it only cares that the
device can not send interrupts it is not allowed to send (e.g.
interrupts to vectors used by other devices or, on x86, exception vectors).
If that is guaranteed by the SMMU or the GIC ITS hardware and driver
then it is fine to set this flag.


	Joerg


