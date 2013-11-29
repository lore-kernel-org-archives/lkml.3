Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3K2HUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:20:23 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:50138 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3K2HTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:19:51 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 2/3 v2] usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
Date: Fri, 29 Nov 2013 15:19:45 +0800
Message-Id: <1385709585-10459-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag

* init the sts flag to 0 (missed)
* set the sts flag only if not 0

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/usb/chipidea/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 5075407..1a6010e 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -245,6 +245,8 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
 {
 	u32 portsc, lpm, sts = 0;
 
 	switch (ci->platdata->phy_mode) {
 	case USBPHY_INTERFACE_MODE_UTMI:
 		portsc = PORTSC_PTS(PTS_UTMI);
@@ -273,10 +275,12 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
 
 	if (ci->hw_bank.lpm) {
 		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
-		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
+		if (sts)
+			hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
 	} else {
 		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
-		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
+		if ( sts )
+			hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
 	}
 }
 
-- 
1.7.10.4

