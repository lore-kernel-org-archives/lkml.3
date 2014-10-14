Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaJNOtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:49:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:9508 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbaJNOtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:49:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,717,1406617200"; 
   d="scan'208";a="614288459"
From: Octavian Purdila <octavian.purdila@intel.com>
To: wsa@the-dreams.de
Cc: linux@roeck-us.net, johan@kernel.org, linux-i2c@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH v2 1/3] i2c: document the existing i2c sysfs ABI
Date: Tue, 14 Oct 2014 17:48:12 +0300
Message-Id: <1413298094-9276-2-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
References: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
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
index 0000000..8075585
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
+		Write only entry that allows instantiating a
+		new i2c device on bus X. This is to be used when
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

