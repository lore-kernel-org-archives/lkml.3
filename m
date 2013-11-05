Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab3KEXAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:00:53 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16603 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755403Ab3KEXAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:00:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+0O8l1mxjFtfNFgwj3Dj3ltJMpbUTJbE=
Date: Tue, 5 Nov 2013 18:00:24 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arnaud Ebalard <arno@natisbad.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] net: mv643xx_eth: Add missing phy_addr_set in DT mode
Message-ID: <20131105230024.GB8308@titan.lakedaemon.net>
References: <1383611239-14556-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <87sivacxcf.fsf@natisbad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sivacxcf.fsf@natisbad.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 11:12:00PM +0100, Arnaud Ebalard wrote:
> Hi Jason,
> 
> Jason Gunthorpe <jgunthorpe@obsidianresearch.com> writes:
> 
> > Commit cc9d4598 'net: mv643xx_eth: use of_phy_connect if phy_node
> > present' made the call to phy_scan optional, if the DT has a link to
> > the phy node.
> >
> > However phy_scan has the side effect of calling phy_addr_set, which
> > writes the phy MDIO address to the ethernet controller. If phy_addr_set
> > is not called, and the bootloader has not set the correct address then
> > the driver will fail to function.
> 
> Thanks *a lot* for fixing this one! I had the issue on my ReadyNAS 102
> (Armada 370 based) which I had put on a todo list and temporarily

readynas duo v2?

thx,

Jason.

> workarounded by including a 'ping whatever' call in my u-boot env in
> order to force it to do the init. Without it, I was unable to properly
> use the interface. With your fix, after multiple reboots to test it,
> everything works as expected. So, FWIW: 
> 
> Tested-by: Arnaud Ebalard <arno@natisbad.org>
> 
> Cheers,
> 
> a+
