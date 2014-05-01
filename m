Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbaEAAfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:35:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56609 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEAAfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:35:22 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCHv5 01/15] Documentation: dt: add common bindings for hwspinlock
Date: Wed, 30 Apr 2014 19:34:22 -0500
Message-ID: <1398904476-26200-2-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the generic common bindings used to represent
a hwlock device and use/request locks in a device-tree build.

All the platform-specific hwlock driver implementations need the
number of locks and associated base id for registering the locks
present within the device with the driver core. The number of locks
is represented by 'hwlock-num-locks' property in DT bindings. A
property for base id is not needed in DT binding, as it can be
satisfied using a phandle + args specifier. The args specifier
length is dependent on each vendor-specific implementation and
is represented through the '#hwlock-cells' property.

Note that the document is named hwlock.txt deliberately to keep it
a bit more generic.

Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 .../devicetree/bindings/hwlock/hwlock.txt          | 52 ++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt

diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
new file mode 100644
index 0000000..32381cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
@@ -0,0 +1,52 @@
+Generic hwlock bindings
+=======================
+
+Generic bindings that are common to all the hwlock platform specific driver
+implementations, the retrieved values are used for registering the device
+specific parameters with the hwspinlock core.
+
+The validity and need of these common properties may vary from one platform
+implementation to another. The platform specific bindings should explicitly
+state if a property is mandatory or optional. Please look through the
+individual platform specific hwlock binding documentations for identifying
+the applicable properties.
+
+Common properties:
+- #hwlock-cells:	Specifies the number of cells needed to represent a
+			specific lock.
+- hwlock-num-locks:	Number of locks present in a hwlock device. This
+			property is needed on hwlock devices, where the number
+			of supported locks within a hwlock device cannot be
+			read from a register.
+
+Hwlock Users:
+=============
+
+Nodes that require specific hwlock(s) should specify them using one or more
+properties, each containing a phandle to the hwlock node and an args specifier
+value as indicated by #hwlock-cells. Multiple hwlocks can be requested using
+an array of the phandle and hwlock number specifier tuple.
+
+1. Example of a node using a single specific hwlock:
+
+The following example has a node requesting a hwlock in the bank defined by
+the node hwlock1. hwlock1 is a hwlock provider with an argument specifier
+of length 1.
+
+	node {
+		...
+		hwlocks = <&hwlock1 2>;
+		...
+	};
+
+2. Example of a node using multiple specific hwlocks:
+
+The following example has a node requesting two hwlocks, a hwlock within
+the hwlock device node 'hwlock1' with #hwlock-cells value of 1, and another
+hwlock within the hwlock device node 'hwlock2' with #hwlock-cells value of 2.
+
+	node {
+		...
+		hwlocks = <&hwlock1 2>, <&hwlock2 0 3>;
+		...
+	};
-- 
1.9.2

