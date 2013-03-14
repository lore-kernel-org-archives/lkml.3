Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3CNSU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:20:28 -0400
Received: from zmc.proxad.net ([212.27.53.206]:39943 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934559Ab3CNSUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:20:20 -0400
From: Florian Fainelli <florian@openwrt.org>
To: davem@davemloft.net
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Florian Fainelli <florian@openwrt.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] mv643xx_eth: use mvmdio MDIO bus driver
Date: Thu, 14 Mar 2013 19:08:31 +0100
Message-Id: <1363284515-9865-1-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359473048-26551-1-git-send-email-florian@openwrt.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch converts the mv643xx_eth driver to use the mvmdio MDIO bus driver
instead of rolling its own implementation. As a result, all users of this
mv643xx_eth driver are converted to register an "orion-mdio" platform_device.
The mvmdio driver is also updated to support an interrupt line which reports
SMI error/completion, and to allow traditionnal platform device registration
instead of just device tree.

David, I think it makes sense for you to merge all of this, since we do
not want the architecture files to be desynchronized from the mv643xx_eth to
avoid runtime breakage. The potential for merge conflicts should be very small.

Florian Fainelli (4):
  net: mvmdio: allow platform device style registration
  net: mvmdio: rename base register cookie from smireg to regs
  net: mvmdio: enhance driver to support SMI error/done interrupts
  mv643xx_eth: convert to use the Marvell Orion MDIO driver

 .../devicetree/bindings/net/marvell-orion-mdio.txt |    3 +
 arch/arm/plat-orion/common.c                       |   97 +++++++---
 arch/powerpc/platforms/chrp/pegasos_eth.c          |   20 +++
 arch/powerpc/sysdev/mv64x60_dev.c                  |   14 +-
 drivers/net/ethernet/marvell/Kconfig               |    1 +
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  186 +-------------------
 drivers/net/ethernet/marvell/mvmdio.c              |  111 +++++++++---
 include/linux/mv643xx_eth.h                        |    1 -
 8 files changed, 207 insertions(+), 226 deletions(-)

-- 
1.7.10.4

