Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966623Ab3E2UCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:02:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14704 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934987Ab3E2UBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:01:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18SPqytOZE5xmxApSbJpgIKLHrmm4mkskU=
Date: Wed, 29 May 2013 16:00:53 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/13] net: mv643xx_eth: use phy_disconnect instead
 of phy_detach
Message-ID: <20130529200053.GA31290@titan.lakedaemon.net>
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369855975-21489-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369855975-21489-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Wed, May 29, 2013 at 09:32:43PM +0200, Sebastian Hesselbarth wrote:
> Using a separated mdio bus driver with mvmdio, phy_detach on network device
> removal will not stop the phy and finally lead to NULL pointer dereference
> in mvmdio due to non-existent network device. Use phy_disconnect instead
> to properly stop phy device from accessing network device prior removal of
> the network device.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Note: I observed this behavior when removing a modular mv643xx_eth driver
> after attaching it to a phy handled by (also modular) mvmdio. The mvmdio
> conversion has been done in
> 
> commit c3a07134e6aa5b93a37f72ffa3d11fadf72bf757
>  ("mv643xx_eth: convert to use the Marvell Orion MDIO driver")
> 
> and should go back any -stable version with that commit (propably only 3.9)

It looks like just v3.10-rcX, here.

thx,

Jason.
