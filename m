Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaDQJkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:40:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54778 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752203AbaDQJkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:40:16 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/2] regmap: support regmap over SMBus
Date: Thu, 17 Apr 2014 11:40:10 +0200
Message-Id: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds support for remap over SMBus in case your i2c
adapter does not support regular I2C transfers.

SMBus is a subset of the I2C protocol, often used to access registers
on external devices.

I2C adapters are able to access SMBus devices thanks to the SMBus
emulation layer. In the other hand SMBus adapters may not provide
regular I2C transfers, and thus you may not be able to expose a regmap
if your device is connected to such kind of adapter.
Hence why we need this regmap over SMBus implementation.

Best Regards,

Boris

Changes since v1:
 - add reg_read/reg_write callbacks to the regmap_bus struct

Boris BREZILLON (2):
  regmap: add reg_read/reg_write callbacks to regmap_bus struct
  regmap: i2c: fallback to SMBus if the adapter does not support
    standard I2C

 drivers/base/regmap/regmap-i2c.c | 104 ++++++++++++++++++++++++++++++++++++++-
 drivers/base/regmap/regmap.c     |  26 ++++++++++
 include/linux/regmap.h           |   6 +++
 3 files changed, 134 insertions(+), 2 deletions(-)

-- 
1.8.3.2

