Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaDURLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:11:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56391 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaDURLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:11:19 -0400
Date: Mon, 21 Apr 2014 12:11:18 -0500
From: Andy Gross <agross@codeaurora.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/4] soc: qcom: Add GSBI driver
Message-ID: <20140421171117.GB32485@qualcomm.com>
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
 <1398058244-14099-3-git-send-email-agross@codeaurora.org>
 <20140421165400.GA11778@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421165400.GA11778@joshc.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 11:54:00AM -0500, Josh Cartwright wrote:

<snip>

> > +
> > +struct gsbi_dev {
> > +	struct device	*dev;
> > +	void __iomem	*base;
> 
> You don't really need these.

Old habits die hard.  I'll remove.

<snip>

> > +	if (of_property_read_u32(node, "qcom,mode", &mode)) {
> > +		dev_err(gsbi->dev, "missing mode configuration\n");
> > +		return -EINVAL;
> > +	}
> 
> I'm wondering if you should really be a (very simple) pinctrl driver
> proper.

Perhaps.  But how would i reconcile more than one device node that uses the same
GSBI?  One could still trounce the other unless I only allow one setting of the
GSBI.

<snip>

> > +	clk_prepare_enable(gsbi->hclk);
> > +
> > +	writel_relaxed((mode << GSBI_PROTOCOL_SHIFT), gsbi + GSBI_CTRL_REG);
> 
> Did you mean: gsbi->base + GSBI_CTRL_REG ?

Ouch, how did this get munged.  I'll fix this on resend.

<snip>

> > +
> > +static struct of_device_id gsbi_dt_match[] = {
> 
> const

Will fix.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
