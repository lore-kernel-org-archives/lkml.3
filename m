Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaJIUIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:08:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:50899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaJIUHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:07:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,687,1406617200"; 
   d="scan'208";a="586274772"
From: Octavian Purdila <octavian.purdila@intel.com>
To: wsa@the-dreams.de
Cc: johan@kernel.org, linux-i2c@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 1/3] i2c: document the existing i2c sysfs ABI
Date: Thu,  9 Oct 2014 23:07:13 +0300
Message-Id: <1412885235-14026-2-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
References: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Documentation/ABI/testing/sysfs-bus-i2c which
documents the existing i2c sysfs ABI.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-i2c | 45 +++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c

diff --git a/Documentation/ABI/testing/sysfs-bus-i2c b/Documentation/ABI/testing/sysfs-bus-i2c
new file mode 100644
index 0000000..22c621a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-i2c
@@ -0,0 +1,45 @@
+What:		/sys/bus/i2c/devices/i2c-X
+KernelVersion:	since at least 2.6.12
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		This entry represents a registered i2c bus. X is the
+		bus number and its format is "%d".
+
+What:		/sys/bus/i2c/devices/i2c-X/Y
+What:		/sys/bus/i2c/devices/Y
+KernelVersion:	since at least 2.6.12
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		An i2c device attached to bus X. Format of Y is
+		"%d-%04x" where the first number is the bus number (X)
+		and the second number is the device i2c address.
+
+What:		/sys/bus/i2c/devices/i2c-X/new_device
+KernelVersion:	2.6.31
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		Write only entry that allows the instantiation of a
+		new i2c device to bus X. This is to be used when
+		enumeration mechanism such as ACPI or DT are not
+		present or not used for this device.
+		Format: "%s %hi\n" where the first argument is the
+		device name (no spaces allowed) and the second is the
+		i2c address of the device.
+
+What:		/sys/bus/i2c/devices/i2c-X/delete_device
+KernelVersion:	2.6.31
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		Write only entry that allows the removal of an i2c
+		device from bus X.
+		Format: "%s %hi\n" where the first argument is the
+		device name (no spaces allowed) and the second is the
+		i2c address of the device.
+
+What:		/sys/bus/i2c/devices/i2c-X/i2c-Y
+What:		/sys/bus/i2c/devices/i2c-Y
+KernelVersion:	3.13
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		An i2c device attached to bus X that is enumerated via
+		ACPI. Y is the ACPI device name and its format is "%s".
-- 
1.9.1

