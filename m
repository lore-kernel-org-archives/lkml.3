Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbaBUQa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:30:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53436 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbaBUQa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:30:56 -0500
Date: Fri, 21 Feb 2014 10:30:53 -0600
From: Andy Gross <agross@codeaurora.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch v6 1/2] dmaengine: qcom_bam_dma: Add device tree binding
Message-ID: <20140221163053.GA3102@qualcomm.com>
References: <1392964986-5207-1-git-send-email-agross@codeaurora.org>
 <1392964986-5207-2-git-send-email-agross@codeaurora.org>
 <20140221092657.GD7541@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221092657.GD7541@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 09:26:57AM +0000, Mark Rutland wrote:
> On Fri, Feb 21, 2014 at 06:43:04AM +0000, Andy Gross wrote:
> > Add device tree binding support for the QCOM BAM DMA driver.
> > 
[snip]
> > +Required properties:
> > +- compatible:	Must be "qcom,bam-v1.4.0" for MSM8974 V1
> > +		Must be "qcom,bam-v1.4.1" for MSM8974 V2
> 
> This looks a bit odd. How about:
> 
> - compatible: must contain:
>   * "qcom,bam-v1.4.0" for MSM8974 V1
>   * "qcom,bam-v1.4.1" for MSM8974 V2
> 

Agreed.  I'll fix that.

> > +- reg: Address range for DMA registers
> > +- interrupts: single interrupt for this controller
> 
> This device only has a single interrupt? Or there's only one we care
> about at the moment?
> 

Yes only a single interrupt.  I can remove the s.

> > +- #dma-cells: must be <1>
> > +- clocks: required clock
> > +- clock-names: name of clock
> 
> Either describe the _exact_ name this binding expects for any clocks
> input, or get rid of clock-names. I would prefer the former.

So then I'd use the full name in the driver file.  That's fine.

[snip]
> > +Client:
> > +Required properties:
> > +- dmas: List of dma channel requests
> > +- dma-names: Names of aforementioned requested channels
> 
> Do we really need to describe the client binding? Do we not have a
> generic DMA binding doc we can refer to?
> 

Originally there was more information in the entry.  It was pared down over time
and I didn't go back to referencing the generic doc.  I'll do this and that'll
fix this and your next comment.

[snip]

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
