Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaCDRGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:06:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44475 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaCDRGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:06:49 -0500
Date: Tue, 4 Mar 2014 11:04:01 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: S?ren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        Harini Katakam <harinik@xilinx.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] i2c: Add driver for Cadence I2C controller
Message-ID: <20140304170401.GA18529@joshc.qualcomm.com>
References: <1393632046-20062-1-git-send-email-soren.brinkmann@xilinx.com>
 <8af0e222-6337-4ec4-b718-099a9decc5ec@TX2EHSMHS034.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8af0e222-6337-4ec4-b718-099a9decc5ec@TX2EHSMHS034.ehs.local>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 07:06:29PM -0800, S?ren Brinkmann wrote:
> On Fri, 2014-02-28 at 04:00PM -0800, Soren Brinkmann wrote:
> > Add a driver for the Cadence I2C controller. This controller is for
> > example found in Xilinx Zynq.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  .../devicetree/bindings/i2c/i2c-cadence.txt        |  21 +
> >  MAINTAINERS                                        |   1 +
> >  drivers/i2c/busses/Kconfig                         |   7 +
> >  drivers/i2c/busses/Makefile                        |   1 +
> >  drivers/i2c/busses/i2c-cadence.c                   | 901 +++++++++++++++++++++
> >  5 files changed, 931 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> >  create mode 100644 drivers/i2c/busses/i2c-cadence.c
> > 
> [...]
> > diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> > index f5ed03164d86..7806c1654068 100644
> > --- a/drivers/i2c/busses/Kconfig
> > +++ b/drivers/i2c/busses/Kconfig
> > @@ -375,6 +375,13 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
> >  	help
> >  	  The unit of the TWI clock is kHz.
> >  
> > +config I2C_CADENCE
> > +	tristate "Cadence I2C Controller"
> > +	depends on ARCH_ZYNQ
> This can be reduced to a dependency on COMMON_CLK only, I think.

Do you really need to depend on COMMON_CLK?  Most of the clk_* API's are
properly stubbed when !HAVE_CLK.

Also, you may want to split out the device tree bindings in a separate
patch for separate review.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
