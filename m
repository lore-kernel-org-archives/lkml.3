Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaGQSbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:31:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33221 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaGQSbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:31:13 -0400
Date: Thu, 17 Jul 2014 13:31:10 -0500
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom_bam_dma: Add descriptor flags
Message-ID: <20140717183110.GB17951@qualcomm.com>
References: <1401482990-26486-1-git-send-email-agross@codeaurora.org>
 <20140714163616.GA4387@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714163616.GA4387@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:06:16PM +0530, Vinod Koul wrote:
> On Fri, May 30, 2014 at 03:49:50PM -0500, Andy Gross wrote:
> > This patch adds support for end of transaction (EOT) and notify when done (NWD)
> > hardware descriptor flags.
> > 
> > The EOT flag requests that the peripheral assert an end of transaction interrupt
> > when that descriptor is complete.  It also results in special signaling protocol
> > that is used between the attached peripheral and the core using the DMA
> > controller.  Clients will specify DMA_PREP_INTERRUPT to enable this flag.
> > 
> > The NWD flag requests that the peripheral wait until the data has been fully
> > processed by the peripheral before moving on to the next descriptor.  Clients
> > will specify DMA_PREP_FENCE to enable this flag.
> 
> I am going to apply this, but pls send a follow up patch to add comments on the
> flags and their behaviour. I think it is required!

Will do.

<snip>

> >  #define DESC_FLAG_EOT BIT(14)
> >  #define DESC_FLAG_EOB BIT(13)
> > +#define DESC_FLAG_NWD BIT(12)
> explaining behvaiour will help..

In the followup, I'll put in a lengthy description of the INT/EOT/NWD and how
they are used in the signaling to/from the attached peripheral.


Thanks!

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
