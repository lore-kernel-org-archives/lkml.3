Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbaHEKtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:49:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9343 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbaHEKtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:03 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-99-53e0b69d5092
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 14/29] devicetree: Update Exynos SYSMMU device tree bindings
Date: Tue, 05 Aug 2014 12:47:42 +0200
Message-id: <1407235677-26324-15-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xq7pztz0INnizitfi76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlfHi3DW2gpN6FbuPezUwvlTtYuTkkBAwkbj3
	6DQzhC0mceHeerYuRi4OIYGljBJTZq1ghXD6mCS2XW1nBKliEzCU6HrbBVYlItDLKNHf9IMJ
	xGEWWMcqsb/3OgtIlbCAj8Sc1Y1AHRwcLAKqEucPloGEeQU8Jb4cOscOsU5O4v/LFUwgNidQ
	/PDNA6wgtpCAh8TPDWvYJzDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREjdfdzAu
	PWZ1iFGAg1GJh1dh791gIdbEsuLK3EOMEhzMSiK8EmseBAvxpiRWVqUW5ccXleakFh9iZOLg
	lGpgvKq0p2+G0rLys6a5/o+OxH2JlF6+fc4X5fOXIr/e597ck2iW7vFsW56sg8G8ncbsR829
	p9z7NnH2oZ9/itu0r+aJ+nK8VT19SuumcaFoz4bZ0ovTPzB3q2a4uOR9C829IM+yx3VvAENK
	/aZUqeyj85ZdSRc42rklt+kdb+o9ob/iMy+sSbg0SYmlOCPRUIu5qDgRAMN/KWF5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch describes how generic iommu bindings are implemented by
Exynos SYSMMU driver.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../devicetree/bindings/iommu/samsung,sysmmu.txt   | 93 +++++++++++++++++++---
 1 file changed, 84 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
index 6fa4c73..999ba6d 100644
--- a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
+++ b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
@@ -23,16 +23,33 @@ MMUs.
   for window 1, 2 and 3.
 * M2M Scalers and G2D in Exynos5420 has one System MMU on the read channel and
   the other System MMU on the write channel.
-The drivers must consider how to handle those System MMUs. One of the idea is
-to implement child devices or sub-devices which are the client devices of the
-System MMU.
 
-Note:
-The current DT binding for the Exynos System MMU is incomplete.
-The following properties can be removed or changed, if found incompatible with
-the "Generic IOMMU Binding" support for attaching devices to the IOMMU.
+The drivers must consider how to handle those System MMUs. When device
+have more than one SYSMMU controller it is neccessary to add
+"iommu-names" property, which specifies which SYSMMU controller operates
+on which bus or memory channel.
 
-Required properties:
+It is up to the master device driver to decide how such case will be
+handled. It is possible to create separate IO address spaces for each
+SYSMMU or to bind them together to one common IO address space. It is
+also possible to bind more than one device to one IO address space. All
+this has to be handled by master device driver in its initialization
+procedure or flags and no changes to device tree nodes are needed.
+
+In Linux kernel, the general idea is that presence of the SYSMMU
+controllers is transparent to master drivers if they use standard DMA
+API. When driver wants to use IO separate address spaces for each bus or
+memory channel (each SYSMMU) or to bind more than one device to one IO
+address space, it has to specify this to SYSMMU driver by
+DRIVER_HAS_OWN_IOMMU_MANAGER flag. To get access to each SYSMMU bound to
+the given device, additional child devices with special names (matching
+"parent:bus" scheme) have to be registered. Once then, all standard
+IOMMU operations can be performed on such child devices, what will
+result in respective operations done on IO address space managed by
+SYSMMU of the given name. Other operating systems might implement those
+features differently.
+
+Required properties for SYSMMU controller node:
 - compatible: Should be "samsung,exynos-sysmmu"
 - reg: A tuple of base address and size of System MMU registers.
 - interrupt-parent: The phandle of the interrupt controller of System MMU
@@ -45,11 +62,27 @@ Required properties:
 	       Exynos4 SoCs, there needs no "master" clock.
 	       Exynos5 SoCs, some System MMUs must have "master" clocks.
 - clocks: Required if the System MMU is needed to gate its clock.
+- #iommu-cells: Specify number of cells describing IO address space parameters,
+		can be: 0 (zero), meaning all 32bit address space is available,
+		or 2, if address space is limited, first cell then stores
+		base IO address, second cell contains IO window size in bytes.
 - samsung,power-domain: Required if the System MMU is needed to gate its power.
 	  Please refer to the following document:
 	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
 
-Examples:
+Required properties for master device:
+- iommus: one or more phandles to the SYSMMU controller node, with optionally
+	  specified IO address space (see #iommu-cells property above)
+- iommu-names: if more than one SYSMMU controller is specified, this property
+	       must contain names for each of them. Those names are defined by
+	       the bindings for a particular master device.
+
+For more information, please refer to generic iommu bindings defined in
+iommu.txt file.
+
+Example 1:
+GScaller device with one SYSMMU controller
+
 	gsc_0: gsc@13e00000 {
 		compatible = "samsung,exynos5-gsc";
 		reg = <0x13e00000 0x1000>;
@@ -57,6 +90,7 @@ Examples:
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock CLK_GSCL0>;
 		clock-names = "gscl";
+		iommus = <&sysmmu_gsc0>;
 	};
 
 	sysmmu_gsc0: sysmmu@13E80000 {
@@ -67,4 +101,45 @@ Examples:
 		clock-names = "sysmmu", "master";
 		clocks = <&clock CLK_SMMU_GSCL0>, <&clock CLK_GSCL0>;
 		samsung,power-domain = <&pd_gsc>;
+		#iommu-cells = <0>;
+	};
+
+Example 2:
+MFC Codec with two SYSMMU controllers (on "left" and "right" bus), with address
+space limited to 256MiB each, left bus starts IO address space at 0x20000000,
+while right bus at 0x30000000
+
+	mfc: codec@13400000 {
+		compatible = "samsung,mfc-v5";
+		reg = <0x13400000 0x10000>;
+		interrupts = <0 94 0>;
+		samsung,power-domain = <&pd_mfc>;
+		clocks = <&clock CLK_MFC>;
+		clock-names = "mfc";
+		status = "disabled";
+		iommus = <&sysmmu_mfc_l 0x20000000 0x10000000>,
+			 <&sysmmu_mfc_r 0x30000000 0x10000000>;
+		iommu-names = "left", "right";
+	};
+
+	sysmmu_mfc_l: sysmmu@13620000 {
+		compatible = "samsung,exynos-sysmmu";
+		reg = <0x13620000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MFCL>, <&clock CLK_MFC>;
+		samsung,power-domain = <&pd_mfc>;
+		#iommu-cells = <2>;
+	};
+
+	sysmmu_mfc_r: sysmmu@13630000 {
+		compatible = "samsung,exynos-sysmmu";
+		reg = <0x13630000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MFCR>, <&clock CLK_MFC>;
+		samsung,power-domain = <&pd_mfc>;
+		#iommu-cells = <2>;
 	};
-- 
1.9.2

