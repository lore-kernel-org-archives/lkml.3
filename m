Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaBZUXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:23:18 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:35891 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbaBZUXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:23:16 -0500
Date: Wed, 26 Feb 2014 21:22:22 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] net: phy: add suspend_halted module param
Message-ID: <20140226202222.GD14907@lunn.ch>
References: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224191554.GC29288@lunn.ch>
 <530D1B7C.2090506@gmail.com>
 <20140226182117.GB14907@lunn.ch>
 <CAGVrzcYUfq84ryVET9qNJvyFCnhFdU4c0fOHbNN4eE8_w6qsAQ@mail.gmail.com>
 <20140226191009.GC14907@lunn.ch>
 <CAGVrzcb5k1JUPo0kvMdPJLCkWHb9qfHfDif08ud5ydKiKBwdHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcb5k1JUPo0kvMdPJLCkWHb9qfHfDif08ud5ydKiKBwdHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only case we need to handle is when the interface is brought down,
> suspend_halted=true will also power down the PHY, you reboot into
> u-boot, and you attempt a network boot right after that, in that case
> the PHY interface is still powered down and this does not work.

Correct. And since my device uses dhclient, the interface is always
put down on reboot when it releases the lease. 
 
> That could be worked around by putting the interface up again before
> you reboot into u-boot right, that specific logic being gated by
> reading the board model. Agreed, you need to duplicate that workaround
> in all affected user-space....

I wonder how many other systems are broken? Are we considering this a
regression? Should this feature to turned off by default, and a sysfs
knob used to enable it? That is the safe option.

     Andrew
