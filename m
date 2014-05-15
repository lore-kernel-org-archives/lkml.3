Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaEORc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:32:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50335 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaEORcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:32:11 -0400
Date: Thu, 15 May 2014 12:32:06 -0500
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom_bam_dma: Add descriptor flag APIs
Message-ID: <20140515173206.GA16858@qualcomm.com>
References: <1397772242-4048-1-git-send-email-agross@codeaurora.org>
 <20140502162841.GZ32284@intel.com>
 <20140502180827.GA9476@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502180827.GA9476@qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 01:08:27PM -0500, Andy Gross wrote:
> On Fri, May 02, 2014 at 09:58:41PM +0530, Vinod Koul wrote:
> > On Thu, Apr 17, 2014 at 05:04:02PM -0500, Andy Gross wrote:
> > > This patch adds APIs that allow for BAM hardware flags to be set per
> > > descriptor.  Each one of the new flags informs the attached peripheral of a
> > > special behavior that is required.
> > > 
> > > The EOT flag requests that the peripheral assert an end of transaction interrupt
> > > when that descriptor is complete.  It also results in special signaling protocol
> > > that is used between the attached peripheral and the core using the DMA
> > > controller.
> > DMA_PREP_INTERRUPT ??
> 
> I have 3 different IRQs that can be asserted based on the bit I set in the
> hardware descriptor.  The normal IRQ is the INT bit.  However, in some cases the
> peripheral protocol requires the use of the EOT or EOB interrupt instead.  The
> DMA_PREP_INTERRUPT would only work if I had only 2 choices.

Thinking about this more, I could use the DMA_PREP_INTERRUPT to cover the EOT
flag.  However, I might get in a bind later if I need to support the EOB (end of
block) interrupt.

> 
> > 
> > > 
> > > The NWD flag requests that the peripheral wait until the data has been fully
> > > processed before signaling an interrupt.
> > interrupt for transaction complete or DMA request?
> 
> This is a special signaling mechanism that holds off the DMA interrupt until the
> peripheral actually acks that the data has been processed completely.  This is
> required in many cases by the peripheral.  One example is the SPI controller.
> At the end of a transaction you are supposed to set the NWD so that the chip
> select is de-asserted.

I'm not sure what flag I could map this to... maybe DMA_CTRL_ACK?  or maybe the
DMA_PREP_FENCE?  I don't generally like overloading the flags and slightly
twisting their intent.  Could we add a flag to denote device ACK?

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
