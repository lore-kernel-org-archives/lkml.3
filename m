Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaJNUOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:14:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:7185 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbaJNUO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,719,1406617200"; 
   d="scan'208";a="588962067"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] usb: dwc3: be more verbose on ERRATIC_ERROR interrupt
Date: Tue, 14 Oct 2014 13:15:05 -0700
Message-Id: <1413317705-10194-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERRATIC_ERROR interrupt is an event that needs more attention from
developers than currently implemented, since this indicates a serious
stability issue. The only way to get warned about it is by selecting the
maximum driver's verbosity.

This patch increases a bit the error's verbosity.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/dwc3/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3818b26bfc05..132e761d62e4 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2484,7 +2484,8 @@ static void dwc3_gadget_interrupt(struct dwc3 *dwc,
 		dev_vdbg(dwc->dev, "Start of Periodic Frame\n");
 		break;
 	case DWC3_DEVICE_EVENT_ERRATIC_ERROR:
-		dev_vdbg(dwc->dev, "Erratic Error\n");
+		WARN_ON_ONCE(1);
+		dev_dbg(dwc->dev, "Erratic Error\n");
 		break;
 	case DWC3_DEVICE_EVENT_CMD_CMPL:
 		dev_vdbg(dwc->dev, "Command Complete\n");
-- 
2.1.0

