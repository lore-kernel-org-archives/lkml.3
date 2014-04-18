Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaDRQeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:34:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41682 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaDRQeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:34:10 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <prabhakar.csengg@gmail.com>,
        <santosh.shilimkar@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sergei.shtylyov@cogentembedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2 0/4] introduce devm_mdiobus_alloc/free and clean up davinci mdio
Date: Fri, 18 Apr 2014 20:24:53 +0300
Message-ID: <1397841897-9170-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a resource managed devm_mdiobus_alloc()/devm_mdiobus_free()
to automatically clean up MDIO bus alocations made by MDIO drivers,
thus leading to simplified MDIO drivers code.

Clean up Davinci MDIO driver and use new devm API.

Changes in v2:
- minor comments taken into account
- additional patches added for cleaning up Davinci MDIO driver

Cc: Florian Fainelli <f.fainelli@gmail.com>

Grygorii Strashko (4):
  mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
  net: davinci_mdio: use devm_* api
  net: davinci_mdio: drop pinctrl_pm_select_default_state from probe
  net: davinci_mdio: simplify IO memory mapping

 Documentation/driver-model/devres.txt  |    4 ++
 drivers/net/ethernet/ti/davinci_mdio.c |   48 ++++------------------
 drivers/net/phy/mdio_bus.c             |   68 ++++++++++++++++++++++++++++++++
 include/linux/phy.h                    |    2 +
 4 files changed, 82 insertions(+), 40 deletions(-)

-- 
1.7.9.5

