Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3KEAhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:37:05 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59873 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753447Ab3KEAhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:37:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+fCWBAHNcgrLLuIXNWqcAPiX61+a+PWqc=
Date: Mon, 4 Nov 2013 19:36:35 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mv643xx_eth: Add missing phy_addr_set in DT mode
Message-ID: <20131105003635.GG3060@titan.lakedaemon.net>
References: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

On Mon, Nov 04, 2013 at 05:27:19PM -0700, Jason Gunthorpe wrote:
> Commit cc9d4598 'net: mv643xx_eth: use of_phy_connect if phy_node

fyi: set core.abbrev = 12 in your git config, according to Linus, 7/8
was a bad decision...

> present' made the call to phy_scan optional, if the DT has a link to
> the phy node.
> 
> However phy_scan has the side effect of calling phy_addr_set, which
> writes the phy MDIO address to the ethernet controller. If phy_addr_set
> is not called, and the bootloader has not set the correct address then
> the driver will fail to function.
> 
> Tested on Kirkwood.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Fixes: cc9d459894b0 "net: mv643xx_eth: use of_phy_connect if phy_node present"
Acked-by: Jason Cooper <jason@lakedaemon.net>

And it should be suitable for v3.11+

thx,

Jason.
