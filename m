Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaBZP2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:28:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33114 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbaBZP2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:28:32 -0500
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>, <balbi@ti.com>,
        <dmurphy@ti.com>, <mugunthanvnm@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 0/8] Input: pixcir_i2c_ts: Add Type-B Multi-touch and DT support
Date: Wed, 26 Feb 2014 17:27:58 +0200
Message-ID: <1393428486-15001-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series does the following

- use devres managed resource allocations
- convert to Type-B multi touch protocol
- support upto 5 fingers with hardware supplied tracking IDs
- device tree support

Changelog:

v2:
- Addressed review comments and re-arranged patch order

v1:
- http://article.gmane.org/gmane.linux.kernel/1616417

cheers,
-roger

---
Roger Quadros (8):
  Input: pixcir_i2c_ts: Use devres managed resource allocations
  Input: pixcir_i2c_ts: Initialize interrupt mode and power mode
  Input: pixcir_i2c_ts: Get rid of pdata->attb_read_val()
  Input: pixcir_i2c_ts: Use Type-B Multi-Touch protocol
  Input: pixcir_i2c_ts: support upto 5 fingers and hardware provided
    tracking IDs
  Input: pixcir_i2c_ts: Implement wakeup from suspend
  Input: pixcir_i2c_ts: Add device tree support
  ARM: dts: am43x-epos-evm: Correct Touch controller info

 .../bindings/input/touchscreen/pixcir_i2c_ts.txt   |  26 ++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/boot/dts/am43x-epos-evm.dts               |  13 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c          | 510 ++++++++++++++++++---
 include/linux/input/pixcir_ts.h                    |  56 ++-
 5 files changed, 545 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt

-- 
1.8.3.2

