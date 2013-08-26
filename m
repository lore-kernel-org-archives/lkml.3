Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3HZQf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:35:26 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:34884 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115Ab3HZQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:35:25 -0400
MIME-Version: 1.0
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        tomk@rgmadvisors.com, Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH] USB: Fix compilation error when CONFIG_PM disabled
Date: Mon, 26 Aug 2013 11:35:14 -0500
Message-Id: <1377534914-7145-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.7.7.6
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a11899c5e699a8d "USB: OHCI: add missing PCI PM callbacks to
ohci-pci.c" Introduced the following compilation errors when power
management is disabled:

drivers/usb/host/ohci-pci.c: In function 'ohci_pci_init':
drivers/usb/host/ohci-pci.c:309:35: error: 'ohci_suspend' undeclared (first use in this function)
drivers/usb/host/ohci-pci.c:309:35: note: each undeclared identifier is reported only once for each function it appears in
drivers/usb/host/ohci-pci.c:310:34: error: 'ohci_resume' undeclared (first use in this function)

ohci_suspend and ohci_resume are only defined when CONFIG_PM is defined
so only use them under CONFIG_PM.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 drivers/usb/host/ohci-pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index 0f1d193..062b410 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -305,9 +305,11 @@ static int __init ohci_pci_init(void)
 
 	ohci_init_driver(&ohci_pci_hc_driver, &pci_overrides);
 
+#ifdef CONFIG_PM
 	/* Entries for the PCI suspend/resume callbacks are special */
 	ohci_pci_hc_driver.pci_suspend = ohci_suspend;
 	ohci_pci_hc_driver.pci_resume = ohci_resume;
+#endif
 
 	return pci_register_driver(&ohci_pci_driver);
 }
-- 
1.7.7.6


-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
