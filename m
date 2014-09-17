Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbaIQSi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:38:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32943 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351AbaIQSiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:38:23 -0400
Message-ID: <5419D511.5010801@ti.com>
Date: Wed, 17 Sep 2014 21:38:09 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] dmaengine: omap-dma: Fix cyclic suspend/resume
References: <1410896757-3848-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1410896757-3848-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vinod,

On 09/16/2014 10:45 PM, Peter Ujfalusi wrote:
> Hi,
> 
> Changes since v2:
> - fix typo in patch two
> - Acked-by added from Russell
> 
> When the audio is paused/resumed (application paused the sream or board suspend)
> the audio was only playing back one period worth of data and then stops because
> the omap_dam_stop() clears the link configuration and it is not restored in
> start.
> 
> Also add memory barrier call to resume path since this could happen right after
> coming out from suspend.

Would it be possible to queue this two patch for 3.17?
This stop/start issue affects not only board suspend/resume, but in all cases
when application pauses the stream as well when we have underrun in ALSA
which would not trigger a full stop and start of audio.

Thanks,
Péter

> Regards,
> Peter
> ---
> Peter Ujfalusi (2):
>   dmaengine: omap-dma: Add memory barrier to dma_resume path
>   dmaengine: omap-dma: Restore the CLINK_CTRL in resume path
> 
>  drivers/dma/omap-dma.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 


