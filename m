Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaFUS4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 14:56:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46592 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaFUS4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 14:56:48 -0400
Date: Sat, 21 Jun 2014 13:56:46 -0500
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [Patch v2 1/3] spi: qup: Remove chip select function
Message-ID: <20140621185646.GA2601@qualcomm.com>
References: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
 <1402601652-24641-2-git-send-email-agross@codeaurora.org>
 <20140621101303.GE5099@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140621101303.GE5099@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 11:13:03AM +0100, Mark Brown wrote:
> On Thu, Jun 12, 2014 at 02:34:10PM -0500, Andy Gross wrote:
> > This patch removes the chip select function.  Chip select should instead be
> > supported using GPIOs, defining the DT entry "cs-gpios", and letting the SPI
> > core assert/deassert the chip select as it sees fit.
> 
> Why?

The chip select control inside the controller is buggy.  It is supposed to
automatically assert the chip select based on the activity in the controller,
but it is buggy and doesn't work at all.  So instead we elect to use GPIOs.

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
