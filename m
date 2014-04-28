Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbaD1UVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:21:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbaD1UVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:21:31 -0400
Message-ID: <1398716440.24318.330.camel@ul30vt.home>
Subject: Re: [RFC PATCH v5 02/11] ARM SMMU: Add capability IOMMU_CAP_DMA_EXEC
From: Alex Williamson <alex.williamson@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "stuart.yoder@freescale.com" <stuart.yoder@freescale.com>,
        Joerg Roedel <joro@8bytes.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Shuah Khan <shuah.kh@samsung.com>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        "moderated list:ARM SMMU DRIVER" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 28 Apr 2014 14:20:40 -0600
In-Reply-To: <20140428193709.GE22135@arm.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1398700371-20096-3-git-send-email-a.motakis@virtualopensystems.com>
	 <20140428193709.GE22135@arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 20:37 +0100, Will Deacon wrote:
> On Mon, Apr 28, 2014 at 04:52:42PM +0100, Antonios Motakis wrote:
> > The ARM SMMU can take an IOMMU_EXEC protection flag in addition to
> > IOMMU_READ and IOMMU_WRITE. Expose this as an IOMMU capability.
> 
> The other way of handling this would be to negate the capability and
> advertise a NOEXEC cap instead. That would need the IOMMU_EXEC flag to
> become IOMMU_NOEXEC and the ARM SMMU driver updating accordingly, but it
> might make more sense if people don't object to mixing positive and negative
> logic in the IOMMU_* flags.
> 
> Any thoughts?

A benefit of doing that would be that the flag becomes enforceable.  As
written in this draft, if a user does not specify EXEC, the mapping may
or may not be executable, depending on the IOMMU capability (assuming
that if EXEC is not supported that it follows READ).  If the flag
changes to NOEXEC, then all the domains in the container should support
it or else the mapping should fail.  We could also avoid the test in
vfio code when doing a mapping and just let the IOMMU driver fail the
map if NOEXEC is unsupported.  Thanks,

Alex

