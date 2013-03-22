Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab3CVO3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:29:53 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:12313 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751805Ab3CVO3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:29:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9Lvua6Cd88yg28RWMdqkTWYIKzCIdF8w=
Date: Fri, 22 Mar 2013 10:29:24 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Florian Fainelli <florian@openwrt.org>
Cc: davem@davemloft.net, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4 v3] mv643xx_eth: use mvmdio MDIO bus driver
Message-ID: <20130322142924.GK13280@titan.lakedaemon.net>
References: <1363284515-9865-1-git-send-email-florian@openwrt.org>
 <1363959568-16976-1-git-send-email-florian@openwrt.org>
 <20130322141423.GJ13280@titan.lakedaemon.net>
 <514C69B7.8090106@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <514C69B7.8090106@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 03:24:55PM +0100, Florian Fainelli wrote:
> Le 03/22/13 15:14, Jason Cooper a écrit :
> >On Fri, Mar 22, 2013 at 02:39:24PM +0100, Florian Fainelli wrote:
> >>Hi all,
> >>
> >>This patch converts the mv643xx_eth driver to use the mvmdio MDIO bus driver
> >>instead of rolling its own implementation. As a result, all users of this
> >>mv643xx_eth driver are converted to register an "orion-mdio" platform_device.
> >>The mvmdio driver is also updated to support an interrupt line which reports
> >>SMI error/completion, and to allow traditionnal platform device registration
> >>instead of just device tree.
> >>
> >>David, I think it makes sense for you to merge all of this, since we do
> >>not want the architecture files to be desynchronized from the mv643xx_eth to
> >>avoid runtime breakage. The potential for merge conflicts should be very small.
> >>
> >>Florian Fainelli (4):
> >>   net: mvmdio: allow platform device style registration
> >>   net: mvmdio: rename base register cookie from smireg to regs
> >>   net: mvmdio: enhance driver to support SMI error/done interrupts
> >>   mv643xx_eth: convert to use the Marvell Orion MDIO driver
> >>
> >>  .../devicetree/bindings/net/marvell-orion-mdio.txt |    3 +
> >>  arch/arm/plat-orion/common.c                       |   54 +++---
> >>  arch/powerpc/platforms/chrp/pegasos_eth.c          |   20 ++
> >>  arch/powerpc/sysdev/mv64x60_dev.c                  |   16 +-
> >>  drivers/net/ethernet/marvell/Kconfig               |    5 +-
> >>  drivers/net/ethernet/marvell/Makefile              |    2 +-
> >>  drivers/net/ethernet/marvell/mv643xx_eth.c         |  195 ++------------------
> >>  drivers/net/ethernet/marvell/mvmdio.c              |  130 ++++++++++---
> >>  include/linux/mv643xx_eth.h                        |    1 -
> >>  9 files changed, 187 insertions(+), 239 deletions(-)
> >
> >Whole series applied on top of v3.9-rc3 and tested on dreamplug
> >(kirkwood DT boot with legacy mv643xx_eth init)
> 
> Ok, thanks! Does that mean that you want these changes to go via
> your tree? David initially applied my v2 of this patchset, and since
> it thouches mostly ethernet driver stuff, I would rather make it go
> via his tree if both of you agree.

Yeah, I thought I should have reworded that after I hit send :)  I
simply meant it applied cleanly against v3.9-rc3, booted, and worked.  I
Acked it so David could take the whole series through his tree.  Sorry
for the confusion.

Now that I can build mv643xx_eth DT on top of this, I'll structure it so
those changes go on top of yours (in David's tree) and try to avoid the
external dependency for the DT bits going though arm-soc.

thx,

Jason.
