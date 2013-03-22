Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab3CVOPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:15:15 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:12866 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753993Ab3CVOPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:15:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ffOK29FfKhMiZ0kCsU9KPjVmK1xDxbbE=
Date: Fri, 22 Mar 2013 10:14:23 -0400
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
Message-ID: <20130322141423.GJ13280@titan.lakedaemon.net>
References: <1363284515-9865-1-git-send-email-florian@openwrt.org>
 <1363959568-16976-1-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363959568-16976-1-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 02:39:24PM +0100, Florian Fainelli wrote:
> Hi all,
> 
> This patch converts the mv643xx_eth driver to use the mvmdio MDIO bus driver
> instead of rolling its own implementation. As a result, all users of this
> mv643xx_eth driver are converted to register an "orion-mdio" platform_device.
> The mvmdio driver is also updated to support an interrupt line which reports
> SMI error/completion, and to allow traditionnal platform device registration
> instead of just device tree.
> 
> David, I think it makes sense for you to merge all of this, since we do
> not want the architecture files to be desynchronized from the mv643xx_eth to
> avoid runtime breakage. The potential for merge conflicts should be very small.
> 
> Florian Fainelli (4):
>   net: mvmdio: allow platform device style registration
>   net: mvmdio: rename base register cookie from smireg to regs
>   net: mvmdio: enhance driver to support SMI error/done interrupts
>   mv643xx_eth: convert to use the Marvell Orion MDIO driver
> 
>  .../devicetree/bindings/net/marvell-orion-mdio.txt |    3 +
>  arch/arm/plat-orion/common.c                       |   54 +++---
>  arch/powerpc/platforms/chrp/pegasos_eth.c          |   20 ++
>  arch/powerpc/sysdev/mv64x60_dev.c                  |   16 +-
>  drivers/net/ethernet/marvell/Kconfig               |    5 +-
>  drivers/net/ethernet/marvell/Makefile              |    2 +-
>  drivers/net/ethernet/marvell/mv643xx_eth.c         |  195 ++------------------
>  drivers/net/ethernet/marvell/mvmdio.c              |  130 ++++++++++---
>  include/linux/mv643xx_eth.h                        |    1 -
>  9 files changed, 187 insertions(+), 239 deletions(-)

Whole series applied on top of v3.9-rc3 and tested on dreamplug
(kirkwood DT boot with legacy mv643xx_eth init)

Tested-by: Jason Cooper <jason@lakedaemon.net>

also, for the bits changing plat-orion:

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
