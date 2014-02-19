Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaBSOPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:15:16 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35783 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaBSOPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:15:04 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Hao <haokexin@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v4 3/4] of: Move testcase FDT data into drivers/of
Date: Wed, 19 Feb 2014 14:14:49 +0000
Message-Id: <1392819290-1044-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The testcase data is usable by any platform. This patch moves it into
the drivers/of directory so it can be included by any architecture.

Using the test cases requires manually adding #include <testcases.dtsi>
to the end of the boards .dtsi file and enabling CONFIG_OF_SELFTEST. Not
pretty though. A useful project would be to make the testcase code
easier to execute.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 arch/arm/boot/dts/testcases/tests-interrupts.dtsi | 58 -----------------------
 arch/arm/boot/dts/testcases/tests-phandle.dtsi    | 39 ---------------
 arch/arm/boot/dts/testcases/tests.dtsi            |  2 -
 arch/arm/boot/dts/versatile-pb.dts                |  4 +-
 drivers/of/testcase-data/testcases.dtsi           |  2 +
 drivers/of/testcase-data/tests-interrupts.dtsi    | 58 +++++++++++++++++++++++
 drivers/of/testcase-data/tests-phandle.dtsi       | 39 +++++++++++++++
 scripts/Makefile.lib                              |  1 +
 8 files changed, 102 insertions(+), 101 deletions(-)
 delete mode 100644 arch/arm/boot/dts/testcases/tests-interrupts.dtsi
 delete mode 100644 arch/arm/boot/dts/testcases/tests-phandle.dtsi
 delete mode 100644 arch/arm/boot/dts/testcases/tests.dtsi
 create mode 100644 drivers/of/testcase-data/testcases.dtsi
 create mode 100644 drivers/of/testcase-data/tests-interrupts.dtsi
 create mode 100644 drivers/of/testcase-data/tests-phandle.dtsi

diff --git a/arch/arm/boot/dts/testcases/tests-interrupts.dtsi b/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
deleted file mode 100644
index c843720bd3e5..000000000000
--- a/arch/arm/boot/dts/testcases/tests-interrupts.dtsi
+++ /dev/null
@@ -1,58 +0,0 @@
-
-/ {
-	testcase-data {
-		interrupts {
-			#address-cells = <1>;
-			#size-cells = <1>;
-			test_intc0: intc0 {
-				interrupt-controller;
-				#interrupt-cells = <1>;
-			};
-
-			test_intc1: intc1 {
-				interrupt-controller;
-				#interrupt-cells = <3>;
-			};
-
-			test_intc2: intc2 {
-				interrupt-controller;
-				#interrupt-cells = <2>;
-			};
-
-			test_intmap0: intmap0 {
-				#interrupt-cells = <1>;
-				#address-cells = <0>;
-				interrupt-map = <1 &test_intc0 9>,
-						<2 &test_intc1 10 11 12>,
-						<3 &test_intc2 13 14>,
-						<4 &test_intc2 15 16>;
-			};
-
-			test_intmap1: intmap1 {
-				#interrupt-cells = <2>;
-				interrupt-map = <0x5000 1 2 &test_intc0 15>;
-			};
-
-			interrupts0 {
-				interrupt-parent = <&test_intc0>;
-				interrupts = <1>, <2>, <3>, <4>;
-			};
-
-			interrupts1 {
-				interrupt-parent = <&test_intmap0>;
-				interrupts = <1>, <2>, <3>, <4>;
-			};
-
-			interrupts-extended0 {
-				reg = <0x5000 0x100>;
-				interrupts-extended = <&test_intc0 1>,
-						      <&test_intc1 2 3 4>,
-						      <&test_intc2 5 6>,
-						      <&test_intmap0 1>,
-						      <&test_intmap0 2>,
-						      <&test_intmap0 3>,
-						      <&test_intmap1 1 2>;
-			};
-		};
-	};
-};
diff --git a/arch/arm/boot/dts/testcases/tests-phandle.dtsi b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
deleted file mode 100644
index 0007d3cd7dc2..000000000000
--- a/arch/arm/boot/dts/testcases/tests-phandle.dtsi
+++ /dev/null
@@ -1,39 +0,0 @@
-
-/ {
-	testcase-data {
-		phandle-tests {
-			provider0: provider0 {
-				#phandle-cells = <0>;
-			};
-
-			provider1: provider1 {
-				#phandle-cells = <1>;
-			};
-
-			provider2: provider2 {
-				#phandle-cells = <2>;
-			};
-
-			provider3: provider3 {
-				#phandle-cells = <3>;
-			};
-
-			consumer-a {
-				phandle-list =	<&provider1 1>,
-						<&provider2 2 0>,
-						<0>,
-						<&provider3 4 4 3>,
-						<&provider2 5 100>,
-						<&provider0>,
-						<&provider1 7>;
-				phandle-list-names = "first", "second", "third";
-
-				phandle-list-bad-phandle = <12345678 0 0>;
-				phandle-list-bad-args = <&provider2 1 0>,
-							<&provider3 0>;
-				empty-property;
-				unterminated-string = [40 41 42 43];
-			};
-		};
-	};
-};
diff --git a/arch/arm/boot/dts/testcases/tests.dtsi b/arch/arm/boot/dts/testcases/tests.dtsi
deleted file mode 100644
index 3f123ecc9dd7..000000000000
--- a/arch/arm/boot/dts/testcases/tests.dtsi
+++ /dev/null
@@ -1,2 +0,0 @@
-/include/ "tests-phandle.dtsi"
-/include/ "tests-interrupts.dtsi"
diff --git a/arch/arm/boot/dts/versatile-pb.dts b/arch/arm/boot/dts/versatile-pb.dts
index f43907c40c93..65f657711323 100644
--- a/arch/arm/boot/dts/versatile-pb.dts
+++ b/arch/arm/boot/dts/versatile-pb.dts
@@ -1,4 +1,4 @@
-/include/ "versatile-ab.dts"
+#include <versatile-ab.dts>
 
 / {
 	model = "ARM Versatile PB";
@@ -47,4 +47,4 @@
 	};
 };
 
-/include/ "testcases/tests.dtsi"
+#include <testcases.dtsi>
diff --git a/drivers/of/testcase-data/testcases.dtsi b/drivers/of/testcase-data/testcases.dtsi
new file mode 100644
index 000000000000..3cc2f55534ac
--- /dev/null
+++ b/drivers/of/testcase-data/testcases.dtsi
@@ -0,0 +1,2 @@
+#include "tests-phandle.dtsi"
+#include "tests-interrupts.dtsi"
diff --git a/drivers/of/testcase-data/tests-interrupts.dtsi b/drivers/of/testcase-data/tests-interrupts.dtsi
new file mode 100644
index 000000000000..c843720bd3e5
--- /dev/null
+++ b/drivers/of/testcase-data/tests-interrupts.dtsi
@@ -0,0 +1,58 @@
+
+/ {
+	testcase-data {
+		interrupts {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			test_intc0: intc0 {
+				interrupt-controller;
+				#interrupt-cells = <1>;
+			};
+
+			test_intc1: intc1 {
+				interrupt-controller;
+				#interrupt-cells = <3>;
+			};
+
+			test_intc2: intc2 {
+				interrupt-controller;
+				#interrupt-cells = <2>;
+			};
+
+			test_intmap0: intmap0 {
+				#interrupt-cells = <1>;
+				#address-cells = <0>;
+				interrupt-map = <1 &test_intc0 9>,
+						<2 &test_intc1 10 11 12>,
+						<3 &test_intc2 13 14>,
+						<4 &test_intc2 15 16>;
+			};
+
+			test_intmap1: intmap1 {
+				#interrupt-cells = <2>;
+				interrupt-map = <0x5000 1 2 &test_intc0 15>;
+			};
+
+			interrupts0 {
+				interrupt-parent = <&test_intc0>;
+				interrupts = <1>, <2>, <3>, <4>;
+			};
+
+			interrupts1 {
+				interrupt-parent = <&test_intmap0>;
+				interrupts = <1>, <2>, <3>, <4>;
+			};
+
+			interrupts-extended0 {
+				reg = <0x5000 0x100>;
+				interrupts-extended = <&test_intc0 1>,
+						      <&test_intc1 2 3 4>,
+						      <&test_intc2 5 6>,
+						      <&test_intmap0 1>,
+						      <&test_intmap0 2>,
+						      <&test_intmap0 3>,
+						      <&test_intmap1 1 2>;
+			};
+		};
+	};
+};
diff --git a/drivers/of/testcase-data/tests-phandle.dtsi b/drivers/of/testcase-data/tests-phandle.dtsi
new file mode 100644
index 000000000000..0007d3cd7dc2
--- /dev/null
+++ b/drivers/of/testcase-data/tests-phandle.dtsi
@@ -0,0 +1,39 @@
+
+/ {
+	testcase-data {
+		phandle-tests {
+			provider0: provider0 {
+				#phandle-cells = <0>;
+			};
+
+			provider1: provider1 {
+				#phandle-cells = <1>;
+			};
+
+			provider2: provider2 {
+				#phandle-cells = <2>;
+			};
+
+			provider3: provider3 {
+				#phandle-cells = <3>;
+			};
+
+			consumer-a {
+				phandle-list =	<&provider1 1>,
+						<&provider2 2 0>,
+						<0>,
+						<&provider3 4 4 3>,
+						<&provider2 5 100>,
+						<&provider0>,
+						<&provider1 7>;
+				phandle-list-names = "first", "second", "third";
+
+				phandle-list-bad-phandle = <12345678 0 0>;
+				phandle-list-bad-args = <&provider2 1 0>,
+							<&provider3 0>;
+				empty-property;
+				unterminated-string = [40 41 42 43];
+			};
+		};
+	};
+};
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 49392ecbef17..79c059e70860 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -152,6 +152,7 @@ ld_flags       = $(LDFLAGS) $(ldflags-y)
 dtc_cpp_flags  = -Wp,-MD,$(depfile).pre.tmp -nostdinc                    \
 		 -I$(srctree)/arch/$(SRCARCH)/boot/dts                   \
 		 -I$(srctree)/arch/$(SRCARCH)/boot/dts/include           \
+		 -I$(srctree)/drivers/of/testcase-data                   \
 		 -undef -D__DTS__
 
 # Finds the multi-part object the current object will be linked into
-- 
1.8.3.2

