Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaESIeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:34:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56192 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaESIe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:34:29 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 0/6] Cleanup and fixes for dwc3-omap
Date: Mon, 19 May 2014 14:02:51 +0530
Message-ID: <1400488377-10605-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The series does some refactoring on dwc3_probe()

Patch 1 - Now that we use driver compatible for revision check, remove the unnecessary logic.
Patch 2-4 - reduce the size of dwc3_probe()
Patch 5 - Fix the crash on dwc3_omap removal
Patch 6 - Addresses the issue of  xhci hang while resuming from system sleep.


George Cherian (6):
  usb: dwc3: dwc3-omap: Remove x_major calculation from revision
    register
  usb: dwc3: dwc3-omap: Add dwc3_omap_map_offset() function
  usb: dwc3: dwc3-omap: Add dwc3_omap_set_utmi_mode() function
  usb: dwc3: dwc3-omap: Add dwc3_omap_extcon_register function
  usb: dwc3: dwc3-omap: Fix the crash on module removal
  usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in
    prepare/complete

 drivers/usb/dwc3/dwc3-omap.c | 186 ++++++++++++++++++++++---------------------
 1 file changed, 97 insertions(+), 89 deletions(-)

-- 
1.8.3.1

