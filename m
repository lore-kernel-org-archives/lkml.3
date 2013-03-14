Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3CNUgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:36:55 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52109 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751671Ab3CNUgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:36:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+yK5xbHE0CvGms0yKFwl5gSsOtrMc2oyQ=
Date: Thu, 14 Mar 2013 16:36:37 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Florian Fainelli <florian@openwrt.org>
Cc: davem@davemloft.net,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] mv643xx_eth: convert to use the Marvell Orion MDIO
 driver
Message-ID: <20130314203637.GX12700@titan.lakedaemon.net>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
 <1363284515-9865-1-git-send-email-florian@openwrt.org>
 <1363284515-9865-2-git-send-email-florian@openwrt.org>
 <20130314190235.GW12700@titan.lakedaemon.net>
 <514225E9.9060902@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <514225E9.9060902@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 08:32:57PM +0100, Florian Fainelli wrote:
> Hello Jason,
> 
> Le 14/03/2013 20:02, Jason Cooper a écrit :
> >Florian,
> >
> >On Thu, Mar 14, 2013 at 07:08:32PM +0100, Florian Fainelli wrote:
> >>This patch converts the Marvell MV643XX ethernet driver to use the
> >>Marvell Orion MDIO driver. As a result, PowerPC and ARM platforms
> >>registering the Marvell MV643XX ethernet driver are also updated to
> >>register a Marvell Orion MDIO driver. This driver voluntarily overlaps
> >>with the Marvell Ethernet shared registers because it will use a subset
> >>of this shared register (shared_base + 0x4 - shared_base + 0x84). The
> >>Ethernet driver is also updated to look up for a PHY device using the
> >>Orion MDIO bus driver.
> >>
> >>Signed-off-by: Florian Fainelli <florian@openwrt.org>
> >>---
> >>  arch/arm/plat-orion/common.c               |   97 +++++++++++----
> >>  arch/powerpc/platforms/chrp/pegasos_eth.c  |   20 +++
> >>  arch/powerpc/sysdev/mv64x60_dev.c          |   14 ++-
> >>  drivers/net/ethernet/marvell/Kconfig       |    1 +
> >>  drivers/net/ethernet/marvell/mv643xx_eth.c |  186 ++--------------------------
> >>  include/linux/mv643xx_eth.h                |    1 -
> >>  6 files changed, 117 insertions(+), 202 deletions(-)
> >
> >Isn't this the old version of 4/4 ?
> 
> No this really is v2, but I reformatted just that one and sent it
> without the v2 changelog, you should have received the proper
> version a couple minutes later once I realized my mistake.

Yes, I received both, just making sure.

thx,

Jason.
