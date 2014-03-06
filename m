Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaCFOrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:47:14 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:39663 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaCFOrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:47:11 -0500
Date: Thu, 6 Mar 2014 15:46:00 +0100
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
Message-ID: <20140306144600.GM4780@lunn.ch>
References: <1394107868-26094-1-git-send-email-gregory.clement@free-electrons.com>
 <20140306131429.GJ4780@lunn.ch>
 <5318779C.8030901@free-electrons.com>
 <20140306142117.GL4780@lunn.ch>
 <531886B4.2070002@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531886B4.2070002@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> I think you can use aliases to get the order correct, independent of
> >>> how you list them in DT. That should be a lot safer than assuming
> >>> things are instantiated from top to bottom.
> >>
> >> It sounds interesting, how would you do this?
> > 
> > As there already is in armada-370-xp.dtsi
> > 
> >         aliases {
> >                 eth0 = &eth0;
> >                 eth1 = &eth1;
> >         };
> > 
> > 
> > 	eth0: ethernet@70000 {
> > 	}
> >         eth1: ethernet@74000 {
> > 	}
> > 
> > This at least works for i2c devices. The pdev->id is set using the
> > alias number.
> 
> Well I think it doesn't work with ethernet devices because we already do
> this in aramda-38x.dtsi:
> 
> 	aliases {
> 		gpio0 = &gpio0;
> 		gpio1 = &gpio1;
> 		eth0 = &eth0;
> 		eth1 = &eth1;
> 		eth2 = &eth2;
> 	};
> 
> 	eth1: ethernet@30000 {
> 	}
> 	eth2: ethernet@34000 {
> 	}
> 	eth0: ethernet@70000 {
> 	}

Ah, Erm, O.K. 

It seems to be an i2c thing. Take a look at i2c_add_adapter().

        if (dev->of_node) {
                id = of_alias_get_id(dev->of_node, "i2c");
 
You could put something similar into the ethernet driver.

    Andrew
