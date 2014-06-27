Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaF0S6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:58:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44674 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaF0S6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:58:33 -0400
Date: Fri, 27 Jun 2014 13:58:30 -0500
From: Andy Gross <agross@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Daniel Sneddon <dsneddon@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: qup: Add DMA capabilities
Message-ID: <20140627185830.GB13621@qualcomm.com>
References: <1403816781-31008-1-git-send-email-agross@codeaurora.org>
 <20140627105057.GF23300@sirena.org.uk>
 <20140627155422.GA13621@qualcomm.com>
 <20140627162411.GO32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627162411.GO32514@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 05:24:11PM +0100, Russell King - ARM Linux wrote:

<snip>

> > > It would be better to use the core DMA mapping code rather than open
> > > coding.  This code won't work for vmalloc()ed addresses, or physically
> > > non-contiguous addresses unless there's an IOMMU fixing things up.
> > 
> > Ah, ok.  So I just need a to setup the scatter gather page list and then do a
> > dma_map_sg.  I'll resend once I have this in place.
> 
> Note that DMA from vmalloc'd memory is non-coherent on some platforms,
> even if you use the DMA API.

Thankfully, that isn't the case on this platform.  As as the QUP controller is
only on Qualcomm chipsets, we don't have to worry about it being used on other
platforms.


-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
