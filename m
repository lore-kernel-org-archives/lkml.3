Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbbAVUxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:53:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:48882 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbbAVUxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:53:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="674374534"
Date: Thu, 22 Jan 2015 12:48:51 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de,
        maxime.ripard@free-electrons.com, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, skuribay@pobox.com, Romain.Baeriswyl@abilis.com,
        wenkai.du@intel.com, christian.ruppert@abilis.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH V4 2/2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20150122204851.GA11246@pathfinder>
References: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
 <1421313137-1613-3-git-send-email-david.e.box@linux.intel.com>
 <20150122142819.GG1850@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122142819.GG1850@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Thu, Jan 22, 2015 at 04:28:19PM +0200, Mika Westerberg wrote:
> On Thu, Jan 15, 2015 at 01:12:17AM -0800, David E. Box wrote:
> > This patch implements an I2C bus sharing mechanism between the host and platform
> > hardware on select Intel BayTrail SoC platforms using the X-Powers AXP288 PMIC.
> > 
> > On these platforms access to the PMIC must be shared with platform hardware. The
> > hardware unit assumes full control of the I2C bus and the host must request
> > access through a special semaphore. Hardware control of the bus also makes it
> > necessary to disable runtime pm to avoid interfering with hardware transactions.
> > 
> > Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> 
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> One comment, though:
> 
> > ---
> >  drivers/i2c/busses/Kconfig                   |  11 ++
> >  drivers/i2c/busses/Makefile                  |   1 +
> >  drivers/i2c/busses/i2c-designware-baytrail.c | 160 +++++++++++++++++++++++++++
> >  drivers/i2c/busses/i2c-designware-core.h     |   6 +
> >  drivers/i2c/busses/i2c-designware-platdrv.c  |  20 +++-
> >  5 files changed, 193 insertions(+), 5 deletions(-)
> >  create mode 100644 drivers/i2c/busses/i2c-designware-baytrail.c
> > 
> > diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> > index 917c358..9a83c46 100644
> > --- a/drivers/i2c/busses/Kconfig
> > +++ b/drivers/i2c/busses/Kconfig
> > @@ -464,6 +464,17 @@ config I2C_DESIGNWARE_PCI
> >  	  This driver can also be built as a module.  If so, the module
> >  	  will be called i2c-designware-pci.
> >  
> > +config I2C_DESIGNWARE_BAYTRAIL
> > +	bool "Intel Baytrail I2C semaphore support"
> 
> It would be nice if it was possible to compile this as a module.

In the makefile the driver is now part of the composite object for
I2C_DESIGNWARE_PLATFORM. So if selected it will compile as the platform driver
is compiled. This makes the most sense since the linking doesn't work right if
both drivers aren't built the same. This is really an extension to the platform
driver anyway and not standalone code.

Dave
