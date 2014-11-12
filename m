Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaKLKjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:39:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:1223 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbaKLKjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:39:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,368,1413270000"; 
   d="scan'208";a="621099230"
Date: Wed, 12 Nov 2014 16:10:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Archit Taneja <architt@codeaurora.org>
Cc: agross@codeaurora.org, galak@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dmaengine: qcom_bam_dma: Generalize BAM
 register offset calculations
Message-ID: <20141112104033.GF24582@intel.com>
References: <1411037575-13153-1-git-send-email-architt@codeaurora.org>
 <1411965189-24499-1-git-send-email-architt@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411965189-24499-1-git-send-email-architt@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 10:03:07AM +0530, Archit Taneja wrote:
> The BAM DMA IP comes in different versions. The register offset layout varies
> among these versions. The layouts depend on which generation/family of SoCs they
> belong to.
> 
> The current SoCs(like 8084, 8074) have a layout where the Top level registers
> come in the beginning of the address range, followed by pipe and event
> registers. The BAM revision numbers fall above 1.4.0.
> 
> The older SoCs (like 8064, 8960) have a layout where the pipe registers come
> first, and the top level come later. These have BAM revision numbers lesser than
> 1.4.0.
> 
> It isn't suitable to have macros provide the register offsets with the layouts
> changed. Future BAM revisions may have different register layouts too. The
> register addresses are now calculated by referring a table which contains a base
> offset and multipliers for pipe/evnt/ee registers.
> 
> We have a common function bam_addr() which computes addresses for all the
> registers. When computing address of top level/ee registers, we pass 0 to the
> pipe argument in addr() since they don't have any multiple instances.
> 
> Some of the unused register definitions are removed. We can add new registers as
> we need them.

Applied alll three, thanks

-- 
~Vinod

