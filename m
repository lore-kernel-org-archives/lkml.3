Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbaEHQPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:15:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:57040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbaEHQPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535979573"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>, Lin Wang <bupt.wanglin@gmail.com>,
        Lin Wang <lin.x.wang@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 01/10] xhci: fix wrong port number reported when setting USB2.0 hardware LPM.
Date: Thu,  8 May 2014 19:25:54 +0300
Message-Id: <1399566363-25837-2-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Wang <bupt.wanglin@gmail.com>

This patch fix wrong port number reported when trying to enable/disable
USB2.0 hardware LPM.

Signed-off-by: Lin Wang <lin.x.wang@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3008369..708cb29 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4092,7 +4092,7 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 	field = le32_to_cpu(udev->bos->ext_cap->bmAttributes);
 
 	xhci_dbg(xhci, "%s port %d USB2 hardware LPM\n",
-			enable ? "enable" : "disable", port_num);
+			enable ? "enable" : "disable", port_num + 1);
 
 	if (enable) {
 		/* Host supports BESL timeout instead of HIRD */
-- 
1.8.3.2

