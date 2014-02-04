Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaBDMKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:10:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59864 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaBDMKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:10:32 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-6c-52f0d8b61ad3
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v2 5/5] of: document bindings for reserved-memory nodes
Date: Tue, 04 Feb 2014 13:09:33 +0100
Message-id: <1391515773-6112-6-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAd1tNz4EGVybaGrxd9IxdosPTa3M
	FvOPnGO16H+zkNXiwJ8djBZvejtYLHaue8docbbpDbvF9s4Z7BZfrjxkstj0+BqrxcK2JSwW
	l3fNYbNYe+Quu8WGlweZLJZev8hkseB4C6vFn+lyFqeuf2azmDB9LYvFpvtrGS3+bt/EYvHq
	YBuLxfoZr1ksVu36w+gg6bFm3hpGj9+/JjF6vJ48gdHjcl8vk8fOWXfZPXretLB63Lm2h81j
	85J6j9v/HjN7XDnRxOqx7s8rJo/+vwYefVtWMXp83iTnsXFuaAB/FJdNSmpOZllqkb5dAlfG
	2zVrmAu+GFbM+3SftYHxhXoXIyeHhICJxIKfJ5ggbDGJC/fWs3UxcnEICSxilOievJwZwmll
	kpg84zEbSBWbgKFE19suMFtEYCGjxOd5LCBFzALT2CQ+L3zJCpIQFnCXWH32IQuIzSKgKvFq
	zk2gBg4OXqD4grM1IKaEgILEnEk2IBWcAh4SK27/B6sQAqpYv9BzAiPvAkaGVYyiqQXJBcVJ
	6blGesWJucWleel6yfm5mxjBMfZMegfjqgaLQ4wCHIxKPLwKKh+ChFgTy4orcw8xSnAwK4nw
	mm8DCvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamAsWXBg
	yTrFyysr6idNdTzV/8fnVJHzB5cWh7DbK8RXzLt2YamC39XJKl873UK1v9ZP1XPtXjc5WfRN
	3hqrp00FffdFXvYybLCsPMbzN+plktr73LtXzWMyPi2z7t+Vl+r5/KS81FUe9R08q2rNzy4p
	v/dT2dzmxb6vkVyfFpbNvN3+vX35fj91JZbijERDLeai4kQAu8du/q0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@linaro.org>

Reserved memory nodes allow for the reservation of static (fixed
address) regions, or dynamically allocated regions for a specific
purpose.

[joshc: Based on binding document proposed (in non-patch form) here:
 http://lkml.kernel.org/g/20131030134702.19B57C402A0@trevor.secretlab.ca
 adapted to support #memory-region-cells]

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../bindings/reserved-memory/reserved-memory.txt   |  138 ++++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt

diff --git a/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt b/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
new file mode 100644
index 000000000000..a606ce90c9c4
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
@@ -0,0 +1,138 @@
+*** Reserved memory regions ***
+
+Reserved memory is specified as a node under the /reserved-memory node.
+The operating system shall exclude reserved memory from normal usage
+one can create child nodes describing particular reserved (excluded from
+normal use) memory regions. Such memory regions are usually designed for
+the special usage by various device drivers.
+
+Parameters for each memory region can be encoded into the device tree
+with the following nodes:
+
+/reserved-memory node
+---------------------
+#address-cells, #size-cells (required) - standard definition
+    - Should use the same values as the root node
+#memory-region-cells (required) - dictates number of cells used in the child
+                                  nodes memory-region specifier
+ranges (required) - standard definition
+    - Should be empty
+
+/reserved-memory/ child nodes
+-----------------------------
+Each child of the reserved-memory node specifies one or more regions of
+reserved memory. Each child node may either use a 'reg' property to
+specify a specific range of reserved memory, or a 'size' property with
+optional constraints to request a dynamically allocated block of memory.
+
+Following the generic-names recommended practice, node names should
+reflect the purpose of the node (ie. "framebuffer" or "dma-pool"). Unit
+address (@<address>) should be appended to the name if the node is a
+static allocation.
+
+Properties:
+Requires either a) or b) below.
+a) static allocation
+   reg (required) - standard definition
+b) dynamic allocation
+   size (required) - length based on parent's #size-cells
+                   - Size in bytes of memory to reserve.
+   alignment (optional) - length based on parent's #size-cells
+                        - Address boundary for alignment of allocation.
+   alloc-ranges (optional) - prop-encoded-array (address, length pairs).
+                           - Specifies regions of memory that are
+                             acceptable to allocate from.
+
+If both reg and size are present, then the reg property takes precedence
+and size is ignored.
+
+Additional properties:
+compatible (optional) - standard definition
+    - may contain the following strings:
+        - shared-dma-pool: This indicates a region of memory meant to be
+          used as a shared pool of DMA buffers for a set of devices. It can
+          be used by an operating system to instanciate the necessary pool
+          management subsystem if necessary.
+        - vendor specific string in the form <vendor>,[<device>-]<usage>
+no-map (optional) - empty property
+    - Indicates the operating system must not create a virtual mapping
+      of the region as part of its standard mapping of system memory,
+      nor permit speculative access to it under any circumstances other
+      than under the control of the device driver using the region.
+reusable (optional) - empty property
+    - The operating system can use the memory in this region with the
+      limitation that the device driver(s) owning the region need to be
+      able to reclaim it back. Typically that means that the operating
+      system can use that region to store volatile or cached data that
+      can be otherwise regenerated or migrated elsewhere.
+
+Linux implementation note:
+- If a "linux,cma-default" property is present, then Linux will use the
+  region for the default pool of the contiguous memory allocator.
+
+Device node references to reserved memory
+-----------------------------------------
+Regions in the /reserved-memory node may be referenced by other device
+nodes by adding a memory-region property to the device node.
+
+memory-region (optional) - phandle, specifier pairs to children of /reserved-memory
+
+Example
+-------
+This example defines 3 contiguous regions are defined for Linux kernel:
+one default of all device drivers (named linux,cma@72000000 and 64MiB in size),
+one dedicated to the framebuffer device (named framebuffer@78000000, 8MiB), and
+one for multimedia processing (named multimedia-memory@77000000, 64MiB).
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	memory {
+		reg = <0x40000000 0x40000000>;
+	};
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/* global autoconfigured region for contiguous allocations */
+		linux,cma {
+			compatible = "shared-dma-pool";
+			reusable;
+			#memory-region-cells = <0>;
+			size = <0x4000000>;
+			alignment = <0x2000>;
+			linux,cma-default;
+		};
+
+		display_reserved: framebuffer@78000000 {
+			#memory-region-cells = <0>;
+			reg = <0x78000000 0x800000>;
+		};
+
+		multimedia_reserved: multimedia@77000000 {
+			compatible = "acme,multimedia-memory";
+			#memory-region-cells = <1>;
+			reg = <0x77000000 0x4000000>;
+		};
+	};
+
+	/* ... */
+
+	fb0: video@12300000 {
+		memory-region = <&display_reserved>;
+		/* ... */
+	};
+
+	scaler: scaler@12500000 {
+		memory-region = <&multimedia_reserved 0xdeadbeef>;
+		/* ... */
+	};
+
+	codec: codec@12600000 {
+		memory-region = <&multimedia_reserved 0xfeebdaed>;
+		/* ... */
+	};
+};
-- 
1.7.9.5

