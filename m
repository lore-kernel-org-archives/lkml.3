Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbaD3Ld2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:33:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51835 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758650AbaD3Ld1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:33:27 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sergei.shtylyov@cogentembedded.com>, <prabhakar.csengg@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v3 0/4] introduce devm_mdiobus_alloc/free and clean up davinci mdio
Date: Wed, 30 Apr 2014 15:23:32 +0300
Message-ID: <1398860616-6612-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a resource managed devm_mdiobus_alloc[_size]()/devm_mdiobus_free()
to automatically clean up MDIO bus alocations made by MDIO drivers,
thus leading to simplified MDIO drivers code.

Clean up Davinci MDIO driver and use new devm API.

Changes in v3:
- added devm_mdiobus_alloc_size() and
  devm_mdiobus_alloc() converted to be just a simple wrapper now.

Changes in v2:
- minor comments taken into account
- additional patches added for cleaning up Davinci MDIO driver

Cc: Florian Fainelli <f.fainelli@gmail.com>

Grygorii Strashko (4):
  mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
  net: davinci_mdio: use devm_* api
  net: davinci_mdio: drop pinctrl_pm_select_default_state from probe
  net: davinci_mdio: simplify IO memory mapping

 Documentation/driver-model/devres.txt  |    5 +++
 drivers/net/ethernet/ti/davinci_mdio.c |   48 ++++-------------------
 drivers/net/phy/mdio_bus.c             |   67 ++++++++++++++++++++++++++++++++
 include/linux/phy.h                    |    7 ++++
 4 files changed, 87 insertions(+), 40 deletions(-)

-- 
1.7.9.5

