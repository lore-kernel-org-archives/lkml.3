Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbaCQSCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:02:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38294 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828AbaCQSCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:02:18 -0400
Date: Mon, 17 Mar 2014 12:59:11 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Harini Katakam <harinik@xilinx.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, michals@xilinx.com
Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
Message-ID: <20140317175911.GU18529@joshc.qualcomm.com>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <20140317173017.GW11706@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317173017.GW11706@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 05:30:17PM +0000, Mark Brown wrote:
> On Mon, Mar 17, 2014 at 05:35:36PM +0530, Harini Katakam wrote:
[..]
> > +static int __maybe_unused cdns_spi_suspend(struct device *dev)
> > +{
> 
> This needs to call spi_master_suspend() as well (and similarly on
> resume).

I'm not that familiar with the SPI core, but this seems like an
inversion.  Is there a reason why the SPI master class doesn't implement
suspend/resume() callbacks which handle stopping/starting the queue
automatically for all masters?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
