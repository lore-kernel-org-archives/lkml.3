Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaHYM0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:26:14 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47590 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbaHYM0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:12 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb: chipidea: msm: Use USB PHY API to control PHY state
Date: Mon, 25 Aug 2014 15:26:00 +0300
Message-Id: <1408969561-6662-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHY drivers keep track of the current state of the hardware,
so don't change PHY settings under it.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/chipidea/ci_hdrc_msm.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index d72b9d2..30bdd51 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -20,7 +20,6 @@
 static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 {
 	struct device *dev = ci->gadget.dev.parent;
-	int val;
 
 	switch (event) {
 	case CI_HDRC_CONTROLLER_RESET_EVENT:
@@ -34,10 +33,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 		 * Put the transceiver in non-driving mode. Otherwise host
 		 * may not detect soft-disconnection.
 		 */
-		val = usb_phy_io_read(ci->transceiver, ULPI_FUNC_CTRL);
-		val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
-		val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
-		usb_phy_io_write(ci->transceiver, val, ULPI_FUNC_CTRL);
+		usb_phy_notify_disconnect(ci->transceiver, USB_SPEED_UNKNOWN);
 		break;
 	default:
 		dev_dbg(dev, "unknown ci_hdrc event\n");
-- 
1.9.1

