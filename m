Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaGHR5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:57:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:54836 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbaGHR5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:57:01 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 1/7] xen-pciback: Document the various parameters and attributes in SysFS
Date: Tue,  8 Jul 2014 14:58:23 -0400
Message-Id: <1404845909-13563-2-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1404845909-13563-1-git-send-email-konrad@kernel.org>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Which hadn't been done with the initial commit.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/ABI/testing/sysfs-driver-pciback |   84 ++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-pciback

diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
new file mode 100644
index 0000000..4d2860c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-pciback
@@ -0,0 +1,84 @@
+What:           /sys//module/xen_pciback/parameters/verbose_request
+Date:           Oct 2011
+KernelVersion:  3.1
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                Print to the console the PCI configuration changes caused
+                by the frontend.
+
+What:           /sys/module/xen_pciback/parameters/passthrough
+Date:           Oct 2011
+KernelVersion:  3.1
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                Option to specify how to export PCI topology to guest:
+                0 - (default) Hide the true PCI topology and makes the frontend
+                 there is a single PCI bus with only the exported devices on it.
+                 For example, a device at 03:05.0 will be re-assigned to 00:00.0
+                 while second device at 02:1a.1 will be re-assigned to 00:01.1.
+                1 - Passthrough provides a real view of the PCI topology to the
+                 frontend (for example, a device at 06:01.b will still appear at
+                 06:01.b to the frontend). This is similar to how Xen 2.0.x
+                 exposed PCI devices to its driver domains. This may be required
+                 for drivers which depend on finding their hardware in certain
+                 bus/slot locations.
+
+What:           /sys/module/xen_pciback/parameters/hide
+Date:           Oct 2011
+KernelVersion:  3.1
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                An parenthesis separated list of DDDD:BB:DD.F devices to hide
+                from their native device drivers - so they cannot use them -
+                and Xen pciback to become their owner. That is
+                Domain:Bus:Device.Function, where Domain is optional.
+                Wildcards are permitted. For example:
+                xen-pciback.hide=(04:00.0)(03:01.*) will make the Xen pciback
+                driver the owner of 04:00.0 device and any functions of the
+                03:01.0 device (so 03:01.1, 03:01.2, etc).
+
+What:           /sys/module/xen_pciback/parameters/permissive
+Date:           Oct 2011
+KernelVersion:  3.1
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                Allow non-emulated (raw) access to PCI configuration space by
+                the guest frontend. This can have adverse affect as the guest
+                can destabilize the initial domain.
+
+
+What:           /sys/bus/pci/drivers/pciback/quirks
+Date:           Oct 2011
+KernelVersion:  3.1
+Contact:        xen-devel@lists.xenproject.org
+Description:
+		If the permissive attribute is set, then writing a string in
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
+What:           /sys/bus/pci/drivers/pciback/irq_handler_state
+Date:           Oct 2011
+KernelVersion:  3.1
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                An option to toggle Xen PCI back to acknowledge (or stop)
+                interrupts for the specific device regardless of whether the
+                device is shared, enabled, or on a level interrupt line.
+                Writing a string of DDDD:BB:DD.F will toggle the state.
+                This is Domain:Bus:Device.Function where domain is optional.
-- 
1.7.7.6

