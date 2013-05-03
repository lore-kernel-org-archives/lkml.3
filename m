Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3ECEYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:24:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:60014 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab3ECEYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:24:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,601,1363158000"; 
   d="scan'208";a="331678453"
Date: Fri, 3 May 2013 09:20:38 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, djbw@fb.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: implement suspend/resume callbacks
Message-ID: <20130503035038.GR1960@intel.com>
References: <1366797267-29567-1-git-send-email-ldewangan@nvidia.com>
 <20130430103046.GD1960@intel.com>
 <5182B396.308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182B396.308@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 12:42:30PM -0600, Stephen Warren wrote:
> On 04/30/2013 04:30 AM, Vinod Koul wrote:
> > On Wed, Apr 24, 2013 at 03:24:27PM +0530, Laxman Dewangan wrote:
> >> Implement suspend/resume callbacks to store APB DMA channel's
> >> register on suspend and restore APB DMA channel's register on
> >> resume.
> ...
> > You dont seem to handle suspend when DMA is active? Otherwise looks fine.
> > Stephen, you okay with this patch?
> 
> Yes, I think this looks fine. Sorry for the slow response; I was on
> vacation.
> 
> One question though: Laxman mentioned that DMA clients were responsible
> for suspending their DMA accesses themselves. Does the dmaengine core
> define the semantics here; are DMA drivers supposed to handle suspend
> with active DMAs, or should DMA clients suspend their DMA accesses
> themselves as Laxman suggests? If the latter, I wonder if we actually
> need to save/restore all the registers, since after resume, a new DMA
> access would be started in all cases, which would then reprogram the HW.
No dmaengine doesnt define semantics.

so in case of suspend being invoked when dma is active then driver would need to
stop ongoing DMA and then save. 
But in embedded systems this is not a very typical case, so if your usage
guarantees that this wont happen then it should be okay, but I think it is a
better idea to handle this case.

--
~Vinod
