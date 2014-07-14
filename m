Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaGNKuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:50:03 -0400
Received: from mx0.aculab.com ([213.249.233.131]:44498 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751411AbaGNKtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:49:55 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Varka Bhadram'" <varkabhadram@gmail.com>,
        Jongsung Kim <neidhard.kim@lge.com>,
        "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 1/2] net: cadence: macb: add support for the WOL
Thread-Topic: [PATCH 1/2] net: cadence: macb: add support for the WOL
Thread-Index: AQHPn0zYikOaHHxc8ECwP9EkEv6OOJufYySA
Date: Mon, 14 Jul 2014 10:49:04 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17271AC1@AcuExch.aculab.com>
References: <1405328538-29153-1-git-send-email-neidhard.kim@lge.com>
 <53C3ADB9.4010309@gmail.com>
In-Reply-To: <53C3ADB9.4010309@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram
> On 07/14/2014 02:32 PM, Jongsung Kim wrote:
> > This patch enables the ethtool utility to control the WOL function
> > of the PHY connected to the GEM/MACB. (if supported)
...
> > +static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> > +{
> > +	struct macb *bp = netdev_priv(netdev);
> > +	struct phy_device *phydev = bp->phy_dev;
> > +	int err = -ENODEV;
> > +
> > +	if (phydev)
> > +		err = phy_ethtool_set_wol(phydev, wol);
> > +
> > +	return err;
> > +}
> > +
> 
> I think we can do in this way:
> 
> if (phydev)
> 	return phy_ethtool_set_wol(phydev, wol);
> else
> 	return -ENODEV;
> 
> 
> we can save err. What do you say ...?

I would do:
	if (!phydev)
		return -ENODEV;
	return phy_ethtool_set_wol(phydev, wol);

Although it might even be worth moving the NULL test into the function.
(sort of depends on style and the number of callers who need to do the test.)

	David



