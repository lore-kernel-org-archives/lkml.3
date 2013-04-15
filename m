Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab3DOKSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:18:34 -0400
Received: from 8bytes.org ([85.214.48.195]:43672 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab3DOKSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:18:32 -0400
Date: Mon, 15 Apr 2013 12:18:29 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        tindoh@gmail.com
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
Message-ID: <20130415101829.GP6858@8bytes.org>
References: <20130326144629.GB2727@8bytes.org>
 <51527D74.9080209@jp.fujitsu.com>
 <20130327103122.GK30540@8bytes.org>
 <51591EEE.60401@jp.fujitsu.com>
 <20130402140546.GA15687@8bytes.org>
 <515BD638.8070307@jp.fujitsu.com>
 <1364977479.28127.15.camel@i7.infradead.org>
 <20130405110616.GB6858@8bytes.org>
 <5164EEE6.8000707@jp.fujitsu.com>
 <516BC19D.4090303@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516BC19D.4090303@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Apr 15 12:18:30 2013
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 516bd3f623671557819019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 06:00:13PM +0900, Takao Indoh wrote:
> On DMAR initialization during kdump boot, do you guys agree to change
> order like this?
> 
> Current order:
> (1) Disable translation
> (2) PCI initialization
> (3) Make pgtable and enable translation.
> 
> Order I'm proposing:
> (1) PCI initialization
> (2) Disable translation
> (3) Make pgtable and enable translation.

I think this should work. In fact, translation only needs to be disabled
while the IOMMU hardware is reprogrammed to the new data structures the
kdump kernel set up.

> As Joerg said, if we need to consider the case that kdump kernel is
> compiled without dma-remapping(CONFIG_INTEL_IOMMU is off?), I can update
> my patch to handle such a case properly by adding ifdef
> CONFIG_INTEL_IOMMU.

Thinking about it, this case is a bit more special. If the kdump kernel
has no IOMMU driver at all there is also no code to disable it. So
unless we want to force the kdump kernel to have the driver when the
first kernel had it, I think we also want some quirk (depending on
!CONFIG_INTEL_IOMMU) that disables translation at boot.

I know, its complicated :)


	Joerg


