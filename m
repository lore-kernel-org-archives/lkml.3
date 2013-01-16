Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3APNyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:54:06 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54782 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab3APNyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:54:03 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH v2 00/11] MFD: twl-core: Cleanup part 2 for 3.9
Date: Wed, 16 Jan 2013 14:53:48 +0100
Message-ID: <1358344439-23017-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel,

Changes since v1:
- Patch for zoom-display to avoid build issus with this set

I had a patch on top of this series to move the zoom board to use bl-pwm for
display backlight. Because of this I have not noticed that the zoom-display.c
still have twl related code in upstream.

Cover letter from v1:

Second part of the cleanup of twl-core which aims to make the code a bit more
readable.
It has been tested on: OMAP4 PandaBoard, OMAP4 Blaze, OMAP3 BeagleBoard, OMAP3
Zoom2.

Regards,
Peter
---
Peter Ujfalusi (11):
  ARM: OMAP: zoom-display: Remove the use of TWL4030_MODULE_PWM1
  mfd: twl-core: Clean up module id lookup and definitions
  mfd: twl-core: No need to check for invalid subchip ID
  mfd: twl-core: Use the lookup table to find the correct subchip for
    the modules
  mfd: twl-core: Allocate twl_modules dynamically
  mfd: twl-core: Do not try to call legacy mfd add_children() when
    booted with DT
  mfd: twl-core: Do not create dummy pdata when booted with DT
  mfd: twl-core: Move 'inuse' check early at probe time
  mfd: twl-core: Collect global variables behind one private structure
    (global)
  mfd: twl-core: Remove no longer valid comment regarding to write
    buffer size
  mfd: twl-core: Move twl_i2c_read/write_u8 to header as inline function
 arch/arm/mach-omap2/board-zoom-display.c |  14 +-
 drivers/mfd/twl-core.c                   | 362 ++++++++++++++-----------------
 include/linux/i2c/twl.h                  |  84 +++----
 3 files changed, 212 insertions(+), 248 deletions(-)

-- 
1.8.1

