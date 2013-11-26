Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3KZNF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:05:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38923 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab3KZNF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:05:57 -0500
Date: Tue, 26 Nov 2013 13:05:53 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Florian Meier <florian.meier@koalo.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH] I2C: BCM2835: Linking platform nodes to adapter nodes
Message-ID: <20131126130553.GF25130@opensource.wolfsonmicro.com>
References: <527CB3A1.7050808@koalo.de> <527D1870.8080302@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527D1870.8080302@wwwdotorg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 09:59:28AM -0700, Stephen Warren wrote:
> On 11/08/2013 02:49 AM, Florian Meier wrote:
> > In order to find I2C devices in the device tree, the platform nodes
> > have to be known by the I2C core. Analogous to the i2c-omap driver
> > this requires setting the dev.of_node parameter of the adapter.
> 
> (CCing the I2C maintainers...)
> 
> > diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
> 
> > @@ -299,6 +299,7 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
> >  	strlcpy(adap->name, "bcm2835 I2C adapter", sizeof(adap->name));
> >  	adap->algo = &bcm2835_i2c_algo;
> >  	adap->dev.parent = &pdev->dev;
> > +	adap->dev.of_node = pdev->dev.of_node;
> 
> Ah, that makes sense. Thinking about it now, I'd only ever used i2cget
> etc. to access I2C devices, rather than instantiating drivers from DT.
> 
> That all said, I wonder if the I2C core shouldn't do something like the
> following inside i2c_add_adapter():
> 
> if (!adap->dev.of_node && adap->dev.parent)
> 	adap->dev.of_node = adap->dev.parent->of_node;

Should this not also have an of_node_get to increment the ref
count on the node?

Thanks,
Charles
