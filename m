Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbbA2Oer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:34:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:60908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbbA2Oep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:34:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="scan'208";a="644499415"
Date: Thu, 29 Jan 2015 16:34:41 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 7/8] phy: helpers for USB ULPI PHY registering
Message-ID: <20150129143441.GD2570@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-8-git-send-email-heikki.krogerus@linux.intel.com>
 <20150129050355.GB9098@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150129050355.GB9098@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:03:55PM -0600, Felipe Balbi wrote:
> On Fri, Jan 23, 2015 at 05:12:57PM +0200, Heikki Krogerus wrote:
> > ULPI PHYs need to be bound to their controllers with a
> > lookup. This adds helpers that the ULPI drivers can use to
> > do both, the registration of the PHY and the lookup, at the
> > same time.
> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > ---
> >  drivers/phy/ulpi_phy.h | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >  create mode 100644 drivers/phy/ulpi_phy.h
> > 
> > diff --git a/drivers/phy/ulpi_phy.h b/drivers/phy/ulpi_phy.h
> > new file mode 100644
> > index 0000000..ac49fb6
> > --- /dev/null
> > +++ b/drivers/phy/ulpi_phy.h
> > @@ -0,0 +1,31 @@
> > +#include <linux/phy/phy.h>
> > +
> > +/**
> > + * Helper that registers PHY for a ULPI device and adds a lookup for binding it
> > + * and it's controller, which is always the parent.
> > + */
> > +static inline struct phy
> > +*ulpi_phy_create(struct ulpi *ulpi, struct phy_ops *ops)
> > +{
> > +	struct phy *phy;
> > +	int ret;
> > +
> > +	phy = phy_create(&ulpi->dev, NULL, ops);
> > +	if (IS_ERR(phy))
> > +		return phy;
> > +
> > +	ret = phy_create_lookup(phy, "usb2-phy", dev_name(ulpi->dev.parent));
> 
> I wonder if this would break DT-based boot where PHY phandle is
> available. Kishon ?

If there are of_node for the PHY, we will not use this binding at all.

Br,

-- 
heikki
