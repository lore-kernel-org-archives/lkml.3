Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbbAWPNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:13:14 -0500
Received: from mga14.intel.com ([192.55.52.115]:30550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbbAWPNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:13:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="666508932"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] usb: dwc3: cache hwparams earlier
Date: Fri, 23 Jan 2015 17:12:54 +0200
Message-Id: <1422025978-178336-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So they are available when ULPI interface support is added.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/dwc3/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index b06e88b..a8c9062 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -877,6 +877,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		| (dwc->is_utmi_l1_suspend << 4);
 
 	platform_set_drvdata(pdev, dwc);
+	dwc3_cache_hwparams(dwc);
 
 	ret = dwc3_core_get_phy(dwc);
 	if (ret)
@@ -894,8 +895,6 @@ static int dwc3_probe(struct platform_device *pdev)
 	pm_runtime_get_sync(dev);
 	pm_runtime_forbid(dev);
 
-	dwc3_cache_hwparams(dwc);
-
 	ret = dwc3_alloc_event_buffers(dwc, DWC3_EVENT_BUFFERS_SIZE);
 	if (ret) {
 		dev_err(dwc->dev, "failed to allocate event buffers\n");
-- 
2.1.4

