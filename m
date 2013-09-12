Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3ILPIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:08:22 -0400
Received: from smtp.citrix.com ([66.165.176.89]:24453 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3ILPIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:08:21 -0400
X-IronPort-AV: E=Sophos;i="4.90,891,1371081600"; 
   d="scan'208";a="53287693"
From: Tim Deegan <tim@xen.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ehci-dbgp: drop dead code.
Date: Thu, 12 Sep 2013 16:08:10 +0100
Message-ID: <1378998490-20266-1-git-send-email-tim@xen.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can only reach this spot by breaking out of the scan loop,
so by construction ret > 0.

Found by Coverity, in a copy of this file in the Xen sources.

Signed-off-by: Tim Deegan <tim@xen.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/early/ehci-dbgp.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index 5e29dde..8cfc319 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -568,10 +568,6 @@ try_again:
 		dbgp_printk("Could not find attached debug device\n");
 		goto err;
 	}
-	if (ret < 0) {
-		dbgp_printk("Attached device is not a debug device\n");
-		goto err;
-	}
 	dbgp_endpoint_out = dbgp_desc.bDebugOutEndpoint;
 	dbgp_endpoint_in = dbgp_desc.bDebugInEndpoint;
 
-- 
1.7.10.4

