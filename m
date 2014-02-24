Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaBXUuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:50:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38067 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaBXUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:50:37 -0500
Date: Mon, 24 Feb 2014 14:50:28 -0600
From: Andy Gross <agross@codeaurora.org>
To: Joel Fernandes <joelf@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Ideas/suggestions to avoid repeated locking and reducing too
 many lists with dmaengine?
Message-ID: <20140224205028.GA24339@qualcomm.com>
References: <530B9784.5060904@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B9784.5060904@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 01:03:32PM -0600, Joel Fernandes wrote:
> Hi folks,
> 
> Just wanted your thoughts/suggestions on how we can avoid overhead in the EDMA
> dmaengine driver. I am seeing a lots of performance drop specially for small
> transfers with EDMA versus before raw EDMA was moved to DMAEngine framework
> (atleast 25%).

I've seen roughly the same drop in my testing.  In my case it had to do with the
nature of how work is done using virt-dma.  The virt-dma is predicated on only
letting one transaction be active at a time and it increases the latency for
getting the next transaction off.  For large transactions, it's negligible.  But
for small transactions, it is pretty evident.


> One of the things I am thinking about is the repeated (spin) locking/unlocking
> of the virt_dma_chan->lock or vc->lock. In many cases, there's only 1 user or
> thread requiring to do a DMA, so I feel the locking is unnecessary and potential
> overhead. If there's a sane way to detect this an avoid locking altogether, that
> would be great.

I'd expect the locking to not be the source of the problem, especially with
your use case.

[snip]

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
