Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaCGXLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:11:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51940 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaCGXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:11:10 -0500
Date: Fri, 7 Mar 2014 17:11:08 -0600
From: Andy Gross <agross@codeaurora.org>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [Patch v8 2/2] dmaengine: add Qualcomm BAM dma driver
Message-ID: <20140307231108.GD3241@qualcomm.com>
References: <1393828245-18766-1-git-send-email-agross@codeaurora.org>
 <1393828245-18766-3-git-send-email-agross@codeaurora.org>
 <1393839482.28803.118.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393839482.28803.118.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 09:38:03AM +0000, Shevchenko, Andriy wrote:

<snip>

> > +	if (IS_ERR(bdev->bamclk))
> > +		return PTR_ERR(bdev->bamclk);
> > +
> > +	ret = clk_prepare_enable(bdev->bamclk);
> > +	if (ret) {
> > +		dev_err(bdev->dev, "failed to prepare/enable clock\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = of_property_read_u32(pdev->dev.of_node, "qcom,ee", &bdev->ee);
> > +	if (ret) {
> > +		dev_err(bdev->dev, "Execution environment unspecified\n");
> > +		return ret;
> 
> goto err_disable_clk; ?
> 
> > 
> > +	}
> > +
> > +	ret = bam_init(bdev);
> > +	if (ret)
> > +		return ret;
> 
> Ditto.
> 

Good catch.  I'll fix both of those.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
