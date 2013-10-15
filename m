Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab3JOMb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:31:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60117 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758561Ab3JOMbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:31:25 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: stern@rowland.harvard.edu
Cc: manjunath.goudar@linaro.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] USB: OHCI: Only use ohci_driver_overrides if they are defined
Date: Tue, 15 Oct 2013 13:21:55 +0100
Message-Id: <1381839715-2908-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overrides are optional and many drivers pass NULL, in this case don't
process the overrides so we don't deference a NULL pointer.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/usb/host/ohci-hcd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 21d937a..e26abd5 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1161,6 +1161,9 @@ void ohci_init_driver(struct hc_driver *drv,
 	/* Copy the generic table to drv and then apply the overrides */
 	*drv = ohci_hc_driver;
 
+	if (!over)
+		return;
+
 	drv->product_desc = over->product_desc;
 	drv->hcd_priv_size += over->extra_priv_size;
 	if (over->reset)
-- 
1.7.2.5

