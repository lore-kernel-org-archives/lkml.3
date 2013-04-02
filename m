Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376Ab3DBOFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:05:52 -0400
Received: from 8bytes.org ([85.214.48.195]:53669 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761202Ab3DBOFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:05:50 -0400
Date: Tue, 2 Apr 2013 16:05:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, kexec@lists.infradead.org
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
Message-ID: <20130402140546.GA15687@8bytes.org>
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com>
 <20130326144629.GB2727@8bytes.org>
 <51527D74.9080209@jp.fujitsu.com>
 <20130327103122.GK30540@8bytes.org>
 <51591EEE.60401@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51591EEE.60401@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 16:05:49 2013
X-DSPAM-Confidence: 0.9985
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515ae5bd23671788983539
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 02:45:18PM +0900, Takao Indoh wrote:
> <Current flow on kdump boot>
> enable_IR
>   intel_enable_irq_remapping
>     iommu_disable_irq_remapping  <== IRES/QIES/TES disabled here
>     dmar_disable_qi              <== do nothing
>     dmar_enable_qi               <== QIES enabled
>     intel_setup_irq_remapping    <== IRES enabled

But what we want to do here in the kdumo case is to disable translation
too, right? Because the former kernel might have translation and
irq-remapping enabled and the kdump kernel might be compiled without
support for dma-remapping. So if we don't disable translation here too
the kdump kernel is unable to do DMA.

I agree that disabling translation should be a bit more explicit instead
of the current code.


	Joerg


