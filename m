Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3BANAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:00:41 -0500
Received: from 8bytes.org ([85.214.48.195]:59231 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab3BANAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:00:38 -0500
Date: Fri, 1 Feb 2013 14:00:35 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.khan@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: Re: IO_PAGE_FAULTs on unity mapped regions during amd_iommu_init()
 in Linux 3.4
Message-ID: <20130201130035.GE25591@8bytes.org>
References: <1359657210.6061.3.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657210.6061.3.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Feb  1 14:00:36 2013
X-DSPAM-Confidence: 0.9977
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510bbc7422978662836692
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

On Thu, Jan 31, 2013 at 11:33:30AM -0700, Shuah Khan wrote:
> Access to these ranges continues to work with no errors until AMD IOMMU
> driver disables and re-enables IOMMU in enable_iommus(). These faults
> don't persist and appear between the enable_iommus() call and before
> amd_iommu_init() gets done printing "AMD-Vi: Lazy IO/TLB flushing
> enabled" message.

Hmm, okay. I had a look into the v3.4 sources. This looks like a race
condition. The IOMMUs are enabled in amd_iommu_init_hardware() but the
unity-mapped regions are created later in amd_iommu_init_dma_ops(). This
leaves a small window where the page-faults happen that you see.

But I am not sure why this doesn't hit on 3.7 and above. The race is
still there. Anyway, definitly something that needs to be fixed.


	Joerg


