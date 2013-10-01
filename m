Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3JAVZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:25:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:47498 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3JAVZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:25:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1015,1371106800"; 
   d="scan'208";a="368455354"
From: David Cohen <david.a.cohen@linux.intel.com>
To: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@intel.com>
Subject: [PATCH 1/2] usb: chipidea: cosmetic clean up on pci id list
Date: Tue,  1 Oct 2013 14:29:10 -0700
Message-Id: <1380662951-23781-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Cohen <david.a.cohen@intel.com>

In order to fill a struct with zeroes just the first element needs to
be set to 0, the rest can me omitted. This looks cleaner when reading
the code.

This patch does such clean up change on last item of pci id list.

Signed-off-by: David Cohen <david.a.cohen@intel.com>
---
 drivers/usb/chipidea/ci_hdrc_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci_hdrc_pci.c
index 042320a..08a724b 100644
--- a/drivers/usb/chipidea/ci_hdrc_pci.c
+++ b/drivers/usb/chipidea/ci_hdrc_pci.c
@@ -129,7 +129,7 @@ static DEFINE_PCI_DEVICE_TABLE(ci_hdrc_pci_id_table) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0829),
 		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
 	},
-	{ 0, 0, 0, 0, 0, 0, 0 /* end: all zeroes */ }
+	{ 0 } /* end: all zeroes */
 };
 MODULE_DEVICE_TABLE(pci, ci_hdrc_pci_id_table);
 
-- 
1.8.4.rc3

