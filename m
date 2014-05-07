Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaEGNZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:25:04 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:39228 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933211AbaEGNY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:24:59 -0400
Date: Wed, 7 May 2014 15:21:50 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 02/20] usb: ehci-orion: Add the optional PHY support
Message-ID: <20140507132150.GA23936@lunn.ch>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-3-git-send-email-gregory.clement@free-electrons.com>
 <20140506133341.GE6503@lunn.ch>
 <20140507114006.466347a0@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507114006.466347a0@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:40:06AM +0200, Thomas Petazzoni wrote:
> Dear Andrew Lunn,
> 
> On Tue, 6 May 2014 15:33:41 +0200, Andrew Lunn wrote:
> 
> > > +	priv->phy = devm_phy_get(&pdev->dev, "usb");
> > > +	if (!IS_ERR(priv->phy)) {
> > > +		err = phy_init(priv->phy);
> > > +		if (err)
> > > +			goto err2;
> > > +
> > > +		err = phy_power_on(priv->phy);
> > > +		if (err)
> > > +			goto err3;
> > > +	}
> > 
> > Hi Gregory
> > 
> > What about EPROBE_DEFERRED?
> 
> In v4 (to be submitted soon), I've changed this to:
> 
> 	priv->phy = devm_phy_optional_get(&pdev->dev, "usb");
> 	if (IS_ERR(priv->phy)) {
> 		err = PTR_ERR(priv->phy);
> 		goto err_phy_get;
> 	} else {
> 		err = phy_init(priv->phy);
> 		if (err)
> 			goto err_phy_init;
> 
> 		err = phy_power_on(priv->phy);
> 		if (err)
> 			goto err_phy_power_on;
> 	}
> 
> Thanks to devm_phy_optional_get(), the fact of not having a PHY in the
> DT is not considered an error. So on any error from
> devm_phy_optional_get() (including -EPROBE_DEFER), we simply bail out.
> Does this looks good?

Hi Thomas

That looks good.

To avoid the SATA phy problems we had last time, i would like to test
this on a few systems. Please could you let me know what branch v4 is
in when it is ready.

   Thanks
	Andrew
