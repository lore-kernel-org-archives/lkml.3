Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaGNQTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:19:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42999 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaGNQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:19:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@linuxfoundation.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v5 1/6] xen-pciback: Document the various parameters and attributes in SysFS
Date: Mon, 14 Jul 2014 12:18:51 -0400
Message-Id: <1405354736-7358-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which hadn't been done with the initial commit.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
v2: Dropped the parameters and one that is unlikeable.
---
 Documentation/ABI/testing/sysfs-driver-pciback | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-pciback

diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
new file mode 100644
index 0000000..cdc8340
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-pciback
@@ -0,0 +1,25 @@
+What:           /sys/bus/pci/drivers/pciback/quirks
+Date:           Oct 2011
+KernelVersion:  3.1
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                If the permissive attribute is set, then writing a string in
+                the format of DDDD:BB:DD.F-REG:SIZE:MASK will allow the guest
+                to write and read from the PCI device. That is Domain:Bus:
+                Device.Function-Register:Size:Mask (Domain is optional).
+                For example:
+                #echo 00:19.0-E0:2:FF > /sys/bus/pci/drivers/pciback/quirks
+                will allow the guest to read and write to the configuration
+                register 0x0E.
+
+What:           /sys/bus/pci/drivers/pciback/irq_handlers
+Date:           Oct 2011
+KernelVersion:  3.1
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                A list of all of the PCI devices owned by Xen PCI back and
+                whether Xen PCI backend will acknowledge the interrupts received
+                and the amount of interrupts received. Xen PCI back acknowledges
+                said interrupts only when they are level, shared with another
+                guest, and enabled by the guest.
+
-- 
1.9.3

