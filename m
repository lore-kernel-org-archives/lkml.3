Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbaKTKDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:03:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60432 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbaKTKDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:03:20 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Grygorii Strashko" <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        "Kevin Hilman" <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 0/5] i2c: davinci improvements and fixes
Date: Thu, 20 Nov 2014 12:03:03 +0200
Message-ID: <1416477788-5544-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
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

CC: Sekhar Nori <nsekhar@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com> 

Grygorii Strashko (5):
  i2c: i2c-davinci: switch to use platform_get_irq
  i2c: davinci: query STP always when NACK is received
  i2c: recovery: change input parameter to i2c_adapter for
    prepare/unprepare_recovery
  i2c: davinci: use bus recovery infrastructure
  i2c: davinci: use ICPFUNC to toggle I2C as gpio for bus recovery

 drivers/i2c/busses/i2c-davinci.c          | 196 ++++++++++++++++++++++--------
 drivers/i2c/i2c-core.c                    |   4 +-
 include/linux/i2c.h                       |   4 +-
 include/linux/platform_data/i2c-davinci.h |   1 +
 4 files changed, 148 insertions(+), 57 deletions(-)

-- 
1.9.1

