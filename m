Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbaJDAkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:40:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaJCVmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Bird <tbird20d@gmail.com>, Peter Chen <peter.chen@freescale.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.16 123/357] usb: chipidea: msm: Use USB PHY API to control PHY state
Date: Fri,  3 Oct 2014 14:28:29 -0700
Message-Id: <20141003212937.170744637@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

commit ea290056d7c46f7781ff13801048ed957b96d1a5 upstream.

PHY drivers keep track of the current state of the hardware,
so don't change PHY settings under it.

Cc: Tim Bird <tbird20d@gmail.com>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/ci_hdrc_msm.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -20,7 +20,6 @@
 static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 {
 	struct device *dev = ci->gadget.dev.parent;
-	int val;
 
 	switch (event) {
 	case CI_HDRC_CONTROLLER_RESET_EVENT:
@@ -34,10 +33,7 @@ static void ci_hdrc_msm_notify_event(str
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


