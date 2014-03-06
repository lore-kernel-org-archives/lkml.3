Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaCFOWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:22:31 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:39627 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaCFOWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:22:30 -0500
Date: Thu, 6 Mar 2014 15:21:17 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mvebu: add Device Tree for the Armada 385 RD board
Message-ID: <20140306142117.GL4780@lunn.ch>
References: <1394107868-26094-1-git-send-email-gregory.clement@free-electrons.com>
 <20140306131429.GJ4780@lunn.ch>
 <5318779C.8030901@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5318779C.8030901@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Gregory
> > 
> > I guess checkpatch.pl is probably complaining about missing vendor
> > prefix?
> > 
> 
> yes and also about m25p128 itself because it was not explicitly written
> in Documentation/devicetree/bindings/. Actually it was written to "see the
> "m25p_ids" table in drivers/mtd/devices/m25p80.c for the list of" the compatible
> name.
> 
> For the first warning I can add the vendor part, but for the other warning, do we
> really want to copy the m25p_ids table in Documentation/devicetree/bindings/mtd/m25p80.txt ?

I think the DT Maintainers and checkpatch.pl maintainers need to think
about this. Maybe a regex would be enough in
Documentation/devicetree/bindings/mtd/m25p80.txt?

For the moment i would suggest adding a vendor prefix, but nothing
more.


> >> +			/*
> >> +			 * The Ethernet nodes are not ordered by
> >> +			 * address on purpose. Indeed the first
> >> +			 * Ethernet port of the board (Giga0) is
> >> +			 * located at 0x70000 whereas the the second
> >> +			 * Ethernet(Giga 1) port is located at
> >> +			 * 0x30000.
> >> +			 */
> >> +
> >> +			ethernet@70000 {
> >> +				status = "okay";
> >> +				phy = <&phy0>;
> >> +				phy-mode = "rgmii";
> >> +			};
> >> +
> >> +			ethernet@30000 {
> >> +				status = "okay";
> >> +				phy = <&phy1>;
> >> +				phy-mode = "rgmii";
> >> +			};
> >> +
> > 
> > I think you can use aliases to get the order correct, independent of
> > how you list them in DT. That should be a lot safer than assuming
> > things are instantiated from top to bottom.
> 
> It sounds interesting, how would you do this?

As there already is in armada-370-xp.dtsi

        aliases {
                eth0 = &eth0;
                eth1 = &eth1;
        };


	eth0: ethernet@70000 {
	}
        eth1: ethernet@74000 {
	}

This at least works for i2c devices. The pdev->id is set using the
alias number.

      Andrew



