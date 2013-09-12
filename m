Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3ILTRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:17:25 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:49845 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab3ILTRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:17:24 -0400
Message-ID: <1379013442.11313.5.camel@x220.thuisdomein>
Subject: [PATCH] mei: me: downgrade "suspend" message to debug level
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 12 Sep 2013 21:17:22 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2013 19:17:22.0571 (UTC) FILETIME=[B517EDB0:01CEAFEC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mei_me driver prints "suspend" at error level at each suspend.
Downgrade that uninteresting message to debug level.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Lightly tested (on top of v3.10.10, actually). Should apply cleanly to
v3.11 or current master.

Perhaps a better fix is to remove this message entirely. 

 drivers/misc/mei/pci-me.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 0f26832..02740fc 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -281,7 +281,7 @@ static int mei_me_pci_suspend(struct device *device)
 	if (!dev)
 		return -ENODEV;
 
-	dev_err(&pdev->dev, "suspend\n");
+	dev_dbg(&pdev->dev, "suspend\n");
 
 	mei_stop(dev);
 
-- 
1.8.1.4

