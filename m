Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaEVEDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:03:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34494 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbaEVEDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:03:13 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 0/6] Cleanup and fixes for dwc3-omap
Date: Thu, 22 May 2014 09:31:32 +0530
Message-ID: <1400731298-18442-1-git-send-email-george.cherian@ti.com>
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

 drivers/usb/dwc3/dwc3-omap.c | 187 +++++++++++++++++++++++--------------------
 1 file changed, 98 insertions(+), 89 deletions(-)

-- 
1.8.3.1

