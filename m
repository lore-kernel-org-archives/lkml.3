Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaDUR32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:29:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57006 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaDUR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:29:22 -0400
Date: Mon, 21 Apr 2014 12:26:06 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/4] soc: qcom: Add GSBI driver
Message-ID: <20140421172606.GB11778@joshc.qualcomm.com>
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
 <1398058244-14099-3-git-send-email-agross@codeaurora.org>
 <20140421165400.GA11778@joshc.qualcomm.com>
 <20140421171117.GB32485@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421171117.GB32485@qualcomm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 12:11:18PM -0500, Andy Gross wrote:
> On Mon, Apr 21, 2014 at 11:54:00AM -0500, Josh Cartwright wrote:
> > > +	if (of_property_read_u32(node, "qcom,mode", &mode)) {
> > > +		dev_err(gsbi->dev, "missing mode configuration\n");
> > > +		return -EINVAL;
> > > +	}
> > 
> > I'm wondering if you should really be a (very simple) pinctrl driver
> > proper.
> 
> Perhaps.  But how would i reconcile more than one device node that uses the same
> GSBI?  One could still trounce the other unless I only allow one setting of the
> GSBI.
> 

I don't understand, as long as the pins/functions have been specified
properly to the pinctrl core, I would expect a conflicting configuration
to be rejected.

Anyway, I wouldn't expect the subnodes to be consuming the GSBI pin
configuration anyway (although that could probably be done), instead, I
would expect the GSBI node to consume it's own pin configuration.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
