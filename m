Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3CRMwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:52:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36027 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3CRMv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:51:27 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v3 1/4] usb: phy: nop: Add some parameters to platform data
Date: Mon, 18 Mar 2013 14:51:15 +0200
Message-ID: <1363611078-13002-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363611078-13002-1-git-send-email-rogerq@ti.com>
References: <1363611078-13002-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clk_rate parameter to platform data. If supplied, the
NOP phy driver will program the clock to that rate during probe.

Also add 2 flags, needs_vcc and needs_reset.
If the flag is set and the regulator couldn't be found
then the driver will bail out with -EPROBE_DEFER.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/usb/nop-usb-xceiv.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/nop-usb-xceiv.h b/include/linux/usb/nop-usb-xceiv.h
index 28884c7..148d351 100644
--- a/include/linux/usb/nop-usb-xceiv.h
+++ b/include/linux/usb/nop-usb-xceiv.h
@@ -5,6 +5,11 @@
 
 struct nop_usb_xceiv_platform_data {
 	enum usb_phy_type type;
+	unsigned long clk_rate;
+
+	/* if set fails with -EPROBE_DEFER if can't get regulator */
+	unsigned int needs_vcc:1;
+	unsigned int needs_reset:1;
 };
 
 #if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
-- 
1.7.4.1

