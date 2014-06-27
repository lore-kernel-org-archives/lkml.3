Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaF0Py1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:54:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57938 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaF0Py0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:54:26 -0400
Date: Fri, 27 Jun 2014 10:54:22 -0500
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] spi: qup: Add DMA capabilities
Message-ID: <20140627155422.GA13621@qualcomm.com>
References: <1403816781-31008-1-git-send-email-agross@codeaurora.org>
 <20140627105057.GF23300@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627105057.GF23300@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 11:50:57AM +0100, Mark Brown wrote:
> On Thu, Jun 26, 2014 at 04:06:21PM -0500, Andy Gross wrote:
> 
> > +	if (xfer->rx_buf) {
> > +		rx_dma = dma_map_single(controller->dev, xfer->rx_buf,
> > +			xfer->len, DMA_FROM_DEVICE);
> 
> It would be better to use the core DMA mapping code rather than open
> coding.  This code won't work for vmalloc()ed addresses, or physically
> non-contiguous addresses unless there's an IOMMU fixing things up.

Ah, ok.  So I just need a to setup the scatter gather page list and then do a
dma_map_sg.  I'll resend once I have this in place.


-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
