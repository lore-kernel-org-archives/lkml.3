Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaDRTlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 15:41:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43131 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaDRTlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 15:41:03 -0400
Date: Fri, 18 Apr 2014 14:41:01 -0500
From: Andy Gross <agross@codeaurora.org>
To: Stanimir Vabanov <svarbanov@mm-sol.com>
Cc: Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: qcom_bam_dma: Add v1.3.0 driver support
Message-ID: <20140418194101.GA12607@qualcomm.com>
References: <1397684719-30065-1-git-send-email-agross@codeaurora.org>
 <1397684719-30065-2-git-send-email-agross@codeaurora.org>
 <53505D3F.9000108@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53505D3F.9000108@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 02:01:19AM +0300, Stanimir Vabanov wrote:

<snip>

> >  
> >  static const struct of_device_id bam_of_match[] = {
> > +	{ .compatible = "qcom,bam-v1.3.0", },
> >  	{ .compatible = "qcom,bam-v1.4.0", },
> 
> you could use the of_device_id::data field to switch between different
> versions.
> 
> I mean this:
> 
> static const struct of_device_id bam_of_match[] = {
> 	{ .compatible = "qcom,bam-v1.3.0", .data = &reg_offs_v1_3 },
>   	{ .compatible = "qcom,bam-v1.4.0", .data = &reg_offs_v1_4 },
> }
> 
> and during .probe you will get the correct offsets per version. It then
> could be assigned to a variable in bdev.
> 
> Then the defines could be:
> 
> #define BAM_CTRL(bdev)	(bdev->reg_offs->ctrl_offs + 0x00)
> 
> I'm not sure how many additional code this will be but it looks clearer.


That's not a bad idea.  I'll try this out and see how it looks.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
