Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbaBURWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:22:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57446 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaBURWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:22:08 -0500
Date: Fri, 21 Feb 2014 11:22:06 -0600
From: Andy Gross <agross@codeaurora.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch v6 2/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140221172206.GB3102@qualcomm.com>
References: <1392964986-5207-1-git-send-email-agross@codeaurora.org>
 <1392964986-5207-3-git-send-email-agross@codeaurora.org>
 <20140221093352.GE7541@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221093352.GE7541@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 09:33:52AM +0000, Mark Rutland wrote:
> On Fri, Feb 21, 2014 at 06:43:05AM +0000, Andy Gross wrote:

[snip]
> > +       bdev->bamclk = devm_clk_get(bdev->dev, "bam_clk");
> 
> The binding document should describe the "bam_clk" string in the
> clock-names description.
> 

OK.

> > +       ret = of_property_read_u32(pdev->dev.of_node, "qcom,ee", &bdev->ee);
> > +       if (ret) {
> > +               dev_err(bdev->dev, "EE unspecified\n");
> 
> It would be nice to expand EE to what it stands for, at least in the
> error but possibly the binding too.

I can expand it to execution environment.  This is a trustzone thing and is
required from a security perspective.

> > +static const struct of_device_id bam_of_match[] = {
> > +       { .compatible = "qcom,bam-v1.4.0", },
> > +       { .compatible = "qcom,bam-v1.4.1", },
> 
> What are the differences between the two?
> 
> Is v1.4.1 an extension of v1.4.0?

On second look, the 1.4.1 has hardware fixes.  So the software API is the same.
I thought there were some configuration changes, but that isn't the case.

> Could you have the following in DTs:
> 
>   compatible = "qcom,bam-v1.4.1", "qcom,bam-v1.4.0";
> 
> Then you'd only need the v1.4.0 string in the driver for now.

Good point.  That's easy to change.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
