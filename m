Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025AbaFLECV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 00:02:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57393 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaFLECU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 00:02:20 -0400
Date: Wed, 11 Jun 2014 23:02:17 -0500
From: Andy Gross <agross@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH 1/4] spi: qup: Remove chip select function
Message-ID: <20140612040217.GA32535@qualcomm.com>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
 <1400016884-9568-2-git-send-email-agross@codeaurora.org>
 <1400486858.1464.11.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400486858.1464.11.camel@iivanov-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:07:38AM +0300, Ivan T. Ivanov wrote:
<snip>
 
> > +- num-cs:	total number of chipselects
> 
> My understanding is that "num-cs" have to be parsed by
> master driver, not by core SPI driver.

Right.  I need to parse it and check vs the max cs and use that value to set the
master->num_chipselect

> 
> > -
> > -	/* Disable auto CS toggle and use manual */
> > -	iocontol &= ~SPI_IO_C_MX_CS_MODE;
> 
> Probably we should keep this?

Actually this is cleared in the probe during the initial settings of IO_CONTROL.
So this isn't necessary.


-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
