Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3DWMtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:49:32 -0400
Received: from 8bytes.org ([85.214.48.195]:54267 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab3DWMtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:49:31 -0400
Date: Tue, 23 Apr 2013 14:49:27 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, kexec@lists.infradead.org, wei@aristanetworks.com
Subject: Re: [PATCH v2] intel-iommu: Disable translation if already enabled
Message-ID: <20130423124926.GC2589@8bytes.org>
References: <1366706103-2640-1-git-send-email-indou.takao@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366706103-2640-1-git-send-email-indou.takao@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr 23 14:49:29 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5176835923678416360073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 05:35:03PM +0900, Takao Indoh wrote:
> This patch disables translation(dma-remapping) before its initialization
> if it is already enabled.
> 
> This is needed for kexec/kdump boot. If dma-remapping is enabled in the
> first kernel, it need to be disabled before initializing its page table
> during second kernel boot. Wei Hu also reported that this is needed
> when second kernel boots with intel_iommu=off.
> 
> Basically iommu->gcmd is used to know whether translation is enabled or
> disabled, but it is always zero at boot time even when translation is
> enabled since iommu->gcmd is initialized without considering such a
> case. Therefor this patch synchronizes iommu->gcmd value with global
> command register when iommu structure is allocated.
> 
> Changelog:
> v2:
> - Change subject and patch description
> - Disable translation after dmar_table_init() so that it works when
>   intel_iommu=off is specified.
> 
> v1:
> https://lkml.org/lkml/2013/3/20/707
> 
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> ---
>  drivers/iommu/dmar.c        |   11 ++++++++++-
>  drivers/iommu/intel-iommu.c |   15 +++++++++++++++
>  2 files changed, 25 insertions(+), 1 deletions(-)

Looks good to me, applied to x86/vt-d, thanks Takao.


