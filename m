Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaDDMsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:48:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56219 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaDDMss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:48:48 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <prabhakar.csengg@gmail.com>,
        <santosh.shilimkar@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 0/2] introduce devm_mdiobus_alloc/devm_mdiobus_free
Date: Fri, 4 Apr 2014 16:40:23 +0300
Message-ID: <1396618825-4241-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a resource managed devm_mdiobus_alloc()/devm_mdiobus_free()
to automatically clean up MDIO bus alocations made by MDIO drivers,
thus leading to simplified MDIO drivers code.

Update Davinci MDIO driver ss example of new devm APIs usage.

Grygorii Strashko (2):
  mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
  net: davinci_mdio: use devm_* api

 Documentation/driver-model/devres.txt  |    4 ++
 drivers/net/ethernet/ti/davinci_mdio.c |   21 ++--------
 drivers/net/phy/mdio_bus.c             |   68 ++++++++++++++++++++++++++++++++
 include/linux/phy.h                    |    2 +
 4 files changed, 78 insertions(+), 17 deletions(-)

-- 
1.7.9.5

