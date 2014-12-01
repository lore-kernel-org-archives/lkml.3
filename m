Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaLAPeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:34:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44273 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbaLAPeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:34:46 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 0/5] i2c: davinci improvements and fixes
Date: Mon, 1 Dec 2014 17:34:02 +0200
Message-ID: <1417448047-15236-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains some fixes and improvements for Davinci I2C:
patch 1 - small improvement
patch 2 - fixes "Bus busy" state for some case (was reported long time ago:()

patch 3-5 - converts driver to use I2C bus recovery infrastructure and
adds Davinci I2C bus recovery mechanizm based on using ICPFUNC registers.
These patches are combination of two patches from Ben Gardiner [1] and
Mike Looijmans [2] which i've reworked to use I2C bus recovery infrastructure

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2011-April/047305.html
"[PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC"
[2] https://lkml.org/lkml/2014/2/28/133
"[PATCH] i2c-davinci: Implement a bus recovery that actually works"

Changes in v3:
- minor comments applied

Changes in v2:
- patch 1: error handling improved
- patch 2: commit message updated
- patch 4: minor comments applied
- patch 5: added new optional DT property "ti,has-pfunc"

Link on v2:
 https://lkml.org/lkml/2014/11/26/252

Link on v1:
 http://www.spinics.net/lists/linux-i2c/msg17601.html

CC: Sekhar Nori <nsekhar@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>

Grygorii Strashko (5):
  i2c: i2c-davinci: switch to use platform_get_irq
  i2c: davinci: generate STP always when NACK is received
  i2c: recovery: change input parameter to i2c_adapter for
    prepare/unprepare_recovery
  i2c: davinci: use bus recovery infrastructure
  i2c: davinci: use ICPFUNC to toggle I2C as gpio for bus recovery

 .../devicetree/bindings/i2c/i2c-davinci.txt        |   3 +
 drivers/i2c/busses/i2c-davinci.c                   | 205 +++++++++++++++------
 drivers/i2c/i2c-core.c                             |   4 +-
 include/linux/i2c.h                                |   4 +-
 include/linux/platform_data/i2c-davinci.h          |   1 +
 5 files changed, 159 insertions(+), 58 deletions(-)

-- 
1.9.1

