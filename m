Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaIWOrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:47:17 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62296 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaIWOrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:47:14 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-api@vger.kernel.org (open list:ABI/API),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv7 08/26] driver core: amba: add documentation for binding path 'driver_override'
Date: Tue, 23 Sep 2014 16:46:07 +0200
Message-Id: <1411483586-29304-9-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for alternative binding path 'driver_override' for
AMBA devices.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 Documentation/ABI/testing/sysfs-bus-amba | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-amba

diff --git a/Documentation/ABI/testing/sysfs-bus-amba b/Documentation/ABI/testing/sysfs-bus-amba
new file mode 100644
index 0000000..e7b5467
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-amba
@@ -0,0 +1,20 @@
+What:		/sys/bus/amba/devices/.../driver_override
+Date:		September 2014
+Contact:	Antonios Motakis <a.motakis@virtualopensystems.com>
+Description:
+		This file allows the driver for a device to be specified which
+		will override standard OF, ACPI, ID table, and name matching.
+		When specified, only a driver with a name matching the value
+		written to driver_override will have an opportunity to bind to
+		the device. The override is specified by writing a string to the
+		driver_override file (echo vfio-amba > driver_override)	and may
+		be cleared with an empty string (echo > driver_override).
+		This returns the device to standard matching rules binding.
+		Writing to driver_override does not automatically unbind the
+		device from its current driver or make any attempt to
+		automatically load the specified driver. If no driver with a
+		matching name is currently loaded in the kernel, the device will
+		not bind to any driver. This also allows devices to opt-out of
+		driver binding using a driver_override name such as "none".
+		Only a single driver may be specified in the override, there is
+		no support for parsing delimiters.
-- 
1.8.3.2

