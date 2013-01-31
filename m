Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3AaSfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:35:18 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:59208 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab3AaSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:35:16 -0500
Message-ID: <1359657310.6022.4.camel@x61.thuisdomein>
Subject: [PATCH v2] PCI: pciehp: drop ENTRY messages
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 31 Jan 2013 19:35:10 +0100
In-Reply-To: <1450113.teKM2dvJbO@vostro.rjw.lan>
References: <1359367251.883.13.camel@x61.thuisdomein>
	 <CAErSpo7grYijCUZGWGM4jao+MUqXYQ66q1az6bbKPMX4_Jwcyg@mail.gmail.com>
	 <1450113.teKM2dvJbO@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jan 2013 18:35:10.0343 (UTC) FILETIME=[B33C9970:01CDFFE1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In each suspend and resume cycle my laptop prints these messages at
KERN_INFO level:
    pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
    pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY

and
    pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
    pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY

Drop these messages, that were probably used to debug the suspend and
resume code, but now serve no purpose.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v1 was called "PCI: pciehp: hide ENTRY messages behind ctrl_dbg()".
But Bjorn and Rafael prefer to drop these messages completely.

1) Not even compile tested!

 drivers/pci/hotplug/pciehp_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 939bd1d..7d72c5e 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -293,7 +293,6 @@ static void pciehp_remove(struct pcie_device *dev)
 #ifdef CONFIG_PM
 static int pciehp_suspend (struct pcie_device *dev)
 {
-	dev_info(&dev->device, "%s ENTRY\n", __func__);
 	return 0;
 }
 
@@ -303,7 +302,6 @@ static int pciehp_resume (struct pcie_device *dev)
 	struct slot *slot;
 	u8 status;
 
-	dev_info(&dev->device, "%s ENTRY\n", __func__);
 	ctrl = get_service_data(dev);
 
 	/* reinitialize the chipset's event detection logic */
-- 
1.7.11.7

