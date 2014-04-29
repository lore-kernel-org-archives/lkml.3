Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbaD2Jwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:52:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:32775 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbaD2Jwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:52:49 -0400
MIME-Version: 1.0
X-Originating-IP: [82.67.68.96]
In-Reply-To: <20140428193709.GE22135@arm.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
 <1398700371-20096-3-git-send-email-a.motakis@virtualopensystems.com> <20140428193709.GE22135@arm.com>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Tue, 29 Apr 2014 11:52:29 +0200
Message-ID: <CAG8rG2x9ebs0KQREnrB52Og6-XkrCQ7hJv929QBLWQ4z2m_1WQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 02/11] ARM SMMU: Add capability IOMMU_CAP_DMA_EXEC
To: Will Deacon <will.deacon@arm.com>
Cc: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 9:37 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Apr 28, 2014 at 04:52:42PM +0100, Antonios Motakis wrote:
>> The ARM SMMU can take an IOMMU_EXEC protection flag in addition to
>> IOMMU_READ and IOMMU_WRITE. Expose this as an IOMMU capability.
>
> The other way of handling this would be to negate the capability and
> advertise a NOEXEC cap instead. That would need the IOMMU_EXEC flag to
> become IOMMU_NOEXEC and the ARM SMMU driver updating accordingly, but it
> might make more sense if people don't object to mixing positive and negative
> logic in the IOMMU_* flags.
>
> Any thoughts?
>

I agree, that would be simpler for the user. As it is now we have to
worry about whether the EXEC flac is available just to use the PL330,
with NOEXEC the device would always be usable by default.


> Will



-- 
Antonios Motakis
Virtual Open Systems
