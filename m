Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaIWUCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:02:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:20457 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977AbaIWUCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:02:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,582,1406617200"; 
   d="scan'208";a="607373731"
Date: Tue, 23 Sep 2014 12:58:54 -0700
From: "David E. Box" <david.e.box@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, christian.ruppert@abilis.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH V2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20140923195854.GA9921@pathfinder>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
 <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
 <20140923190057.GN15315@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923190057.GN15315@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Tue, Sep 23, 2014 at 09:00:57PM +0200, Maxime Ripard wrote:
> Hi David,
> 
> On Tue, Sep 23, 2014 at 11:40:26AM -0700, David E. Box wrote:
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
> Sorry for stepping in like this without really knowing your platform,
> but wouldn't using the hwspinlock framework make more sense than
> hardcoding your own internal functions here?

I looked into this but didn't see a clear way on our platform to identify the
semaphore seperately from doing it in the designware platform driver. The way
we can find it now is through evaluating an ACPI _SEM object on every i2c device
that gets probed by the dw driver since at probe time we can get the acpi handle.
Without this handle however there isn't a clear way of evaluating the _SEM
object which would be needed to register a hwspinlock in separate code.

Plus it would still require changes to the designware i2c core, though admittedly
having a generic hwspinlock pointer added to the struct is cleaner.

Dave
