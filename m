Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaIQDOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:14:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:29361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbaIQDOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:14:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,538,1406617200"; 
   d="scan'208";a="574206972"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/1] usb: xhci: fix comment for PORT_DEV_REMOVE
Date: Wed, 17 Sep 2014 11:06:49 +0800
Message-Id: <1410923209-49284-1-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
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
index dace515..2682f18 100644
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

