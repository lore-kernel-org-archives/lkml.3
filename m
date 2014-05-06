Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbaEFLG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:06:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52073 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934579AbaEFLG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:06:27 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v5 0/7] Input: pixcir_i2c_ts: Add Type-B Multi-touch and DT support
Date: Tue, 6 May 2014 14:06:05 +0300
Message-ID: <1399374372-29123-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

This series does the following

- use devres managed resource allocations
- convert to Type-B multi touch protocol
- support upto 5 fingers with hardware supplied tracking IDs
- device tree support

Please queue this for -next (3.16). Thanks.

cheers,
-roger

Changelog:

v5:
- Changed ts->exiting flag to ts->running in patch 2.
- Don't call pixcir_stop() from .suspend() if wakeup is required.

v4:
- Imporved pixcir_stop() as per Dmitry's suggestion.
- Removed unnecessary input_unregister_device() from .remove().

v3:
- Rebased to 3.15-rc3
- Fixed suspend while touchscreen in use
- Fixed module removal while touchscreen in use

v2:
- Addressed review comments and re-arranged patch order

v1:
- http://article.gmane.org/gmane.linux.kernel/1616417

--
Roger Quadros (7):
  Input: pixcir_i2c_ts: Use devres managed resource allocations
  Input: pixcir_i2c_ts - initialize interrupt mode and power mode
  Input: pixcir_i2c_ts: Get rid of pdata->attb_read_val()
  Input: pixcir_i2c_ts: Use Type-B Multi-Touch protocol
  Input: pixcir_i2c_ts: support upto 5 fingers and hardware provided
    tracking IDs
  Input: pixcir_i2c_ts: Implement wakeup from suspend
  Input: pixcir_i2c_ts: Add device tree support

 .../bindings/input/touchscreen/pixcir_i2c_ts.txt   |  26 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/input/touchscreen/pixcir_i2c_ts.c          | 524 ++++++++++++++++++---
 include/linux/input/pixcir_ts.h                    |  56 ++-
 4 files changed, 540 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt

-- 
1.8.3.2

