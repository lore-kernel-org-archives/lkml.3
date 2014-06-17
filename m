Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaFQJcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:32:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40692 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaFQJb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:31:58 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>, <tony@atomide.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v7 0/5] Input: pixcir_i2c_ts: Add Type-B Multi-touch and DT support
Date: Tue, 17 Jun 2014 12:31:42 +0300
Message-ID: <1402997507-9736-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

These are the pending patches that didn't go through in the 3.16 merge window.
Please queue them for -next. Thanks.

The series does the following
- convert to Type-B multi touch protocol
- support upto 5 fingers with hardware supplied tracking IDs
- device tree support

Tony,

The last 2 patches fix the touch screen size property in the device tree since
we now use the unified touch screen properties.

cheers,
-roger

Changelog:

v7:
- Rebased on 3.16-rc1.

v6:
- Use unified touchscreen bindings.
- Update pointer math i.e. bufptr += 4 instead of &bufptr[4];

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

Roger Quadros (5):
  Input: pixcir_i2c_ts: Use Type-B Multi-Touch protocol
  Input: pixcir_i2c_ts: support upto 5 fingers and hardware provided
    tracking IDs
  Input: pixcir_i2c_ts: Add device tree support
  ARM: dts: am43x-epos-evm: Update binding for touchscreen size
  ARM: dts: am437x-gp-evm: Update binding for touchscreen size

 .../bindings/input/touchscreen/pixcir_i2c_ts.txt   |  26 +++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/boot/dts/am437x-gp-evm.dts                |   4 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |   4 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c          | 251 ++++++++++++++++++---
 include/linux/input/pixcir_ts.h                    |  12 +
 6 files changed, 259 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt

-- 
1.8.3.2

