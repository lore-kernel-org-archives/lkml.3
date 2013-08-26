Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3HZOxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:53:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59113 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752006Ab3HZOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:53:54 -0400
Date: Mon, 26 Aug 2013 10:53:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Guenter Roeck <linux@roeck-us.net>, Meelis Roos <mroos@linux.ee>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steve Cotton <steve@s.cotton.clara.co.uk>,
        USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] USB: OHCI: fix build error related to ohci_suspend/resume
In-Reply-To: <20130826042653.GA2778@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1308261051340.1445-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a11899c5e69 (USB: OHCI: add missing PCI PM callbacks to
ohci-pci.c) added missing ohci_suspend and ohci_resume callback
pointers, but forgot that these callbacks are declared and defined
only when CONFIG_PM is enabled.

This patch adds a preprocessor conditional to avoid build errors when
PM is disabled.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---


[as1702]


 drivers/usb/host/ohci-pci.c |    2 ++
 1 file changed, 2 insertions(+)

Index: usb-3.11/drivers/usb/host/ohci-pci.c
===================================================================
--- usb-3.11.orig/drivers/usb/host/ohci-pci.c
+++ usb-3.11/drivers/usb/host/ohci-pci.c
@@ -305,9 +305,11 @@ static int __init ohci_pci_init(void)
 
 	ohci_init_driver(&ohci_pci_hc_driver, &pci_overrides);
 
+#ifdef	CONFIG_PM
 	/* Entries for the PCI suspend/resume callbacks are special */
 	ohci_pci_hc_driver.pci_suspend = ohci_suspend;
 	ohci_pci_hc_driver.pci_resume = ohci_resume;
+#endif
 
 	return pci_register_driver(&ohci_pci_driver);
 }


