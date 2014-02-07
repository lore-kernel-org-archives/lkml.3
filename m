Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaBGRuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:50:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43769 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaBGRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:50:06 -0500
Date: Fri, 7 Feb 2014 11:46:43 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Kumar Gala <galak@codeaurora.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
Message-ID: <20140207174643.GX20228@joshc.qualcomm.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207073952.GA2610@qualcomm.com>
 <20140207165127.GV20228@joshc.qualcomm.com>
 <20140207171834.GF1757@sirena.org.uk>
 <20140207172051.GW20228@joshc.qualcomm.com>
 <20140207173108.GH1757@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207173108.GH1757@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:31:08PM +0000, Mark Brown wrote:
> On Fri, Feb 07, 2014 at 11:20:51AM -0600, Josh Cartwright wrote:
> > On Fri, Feb 07, 2014 at 05:18:34PM +0000, Mark Brown wrote:
> > > On Fri, Feb 07, 2014 at 10:51:27AM -0600, Josh Cartwright wrote:
> > > > 	config SPI_QUP
> > > > 		tristate "Qualcomm SPI Support with QUP interface"
> > > > 		depends on OF
> > > > 		depends on ARM
> 
> > > Does this really depend on ARM?  If so why?
> 
> > The ARM dependency is there for the use of _relaxed io accessor
> > variants.
> 
> That's not ARM only and I thought we were getting generic versions of it
> anyway?  ARMv8, MIPS, Microblaze, Hexagon and SH also define it.

Okay, that's fair.  I'm only vaguely familiar with the generic _relaxed
variants, but until they land, how do we appropriately declare the
dependency to prevent breaking COMPILE_TEST builds on architectures that
don't have them?  Or should we either bother?

Do we need to introduce a HAVE_RELAXED_IO_ACCESSORS selected by those
architectures with support?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
