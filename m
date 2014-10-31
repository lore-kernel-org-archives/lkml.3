Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422875AbaJaCtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:49:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:31449 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422773AbaJaCt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:49:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,291,1413270000"; 
   d="scan'208";a="614496278"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 3/3] usb: xhci: fix comment for PORT_DEV_REMOVE
Date: Fri, 31 Oct 2014 10:38:58 +0800
Message-Id: <1414723138-62776-4-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414723138-62776-1-git-send-email-baolu.lu@linux.intel.com>
References: <1414723138-62776-1-git-send-email-baolu.lu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to xHCI specification, PORT_DEV_REMOVE(bit 30) in PORTSC
true means "Device is non-removable".

Reported-by: Juro Bystricky <jurobystricky@hotmail.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/usb/host/xhci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 2f6131b..4e160db 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -358,7 +358,7 @@ struct xhci_op_regs {
 /* wake on over-current (enable) */
 #define PORT_WKOC_E	(1 << 27)
 /* bits 28:29 reserved */
-/* true: device is removable - for USB 3.0 roothub emulation */
+/* true: device is non-removable - for USB 3.0 roothub emulation */
 #define PORT_DEV_REMOVE	(1 << 30)
 /* Initiate a warm port reset - complete when PORT_WRC is '1' */
 #define PORT_WR		(1 << 31)
-- 
1.9.1

