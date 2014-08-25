Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaHYM0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:26:13 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47591 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444AbaHYM0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:26:12 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] usb: chipidea: msm: Initialize PHY on reset event
Date: Mon, 25 Aug 2014 15:26:01 +0300
Message-Id: <1408969561-6662-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408969561-6662-1-git-send-email-iivanov@mm-sol.com>
References: <1408969561-6662-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize USB PHY after every Link controller reset

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/chipidea/ci_hdrc_msm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index 30bdd51..4935ac3 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -26,6 +26,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
 		writel(0, USB_AHBBURST);
 		writel(0, USB_AHBMODE);
+		usb_phy_init(ci->transceiver);
 		break;
 	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
-- 
1.9.1

