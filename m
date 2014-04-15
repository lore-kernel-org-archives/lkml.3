Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaDOLw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:52:29 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53077 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbaDOLu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:50:56 -0400
From: Mohit Kumar <mohit.kumar@st.com>
To: <spear-devel@list.st.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: [PATCH V8 7/9] SPEAr13XX: dts: Add PCIe node information
Date: Tue, 15 Apr 2014 17:19:49 +0530
Message-ID: <fa5d8aabf3c6a6770462c33426787531cb69bd21.1397555158.git.mohit.kumar@st.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1397555158.git.mohit.kumar@st.com>
References: <cover.1397555158.git.mohit.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

SPEAr1310 and SPEAr1340 supports 3 and 1 PCIe controller respectively.
These controllers are based on synopsys designware controller.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mohit Kumar <mohit.kumar@st.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: spear-devel@list.st.com
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/boot/dts/spear1310.dtsi |   48 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/spear1340.dtsi |   16 ++++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/spear1310.dtsi b/arch/arm/boot/dts/spear1310.dtsi
index 64e7dd5..53f73a2 100644
--- a/arch/arm/boot/dts/spear1310.dtsi
+++ b/arch/arm/boot/dts/spear1310.dtsi
@@ -83,6 +83,54 @@
 			status = "disabled";
 		};
 
+		pcie0: pcie@b1000000 {
+			compatible = "st,spear1340-pcie", "snps,dw-pcie";
+			reg = <0xb1000000 0x4000>;
+			interrupts = <0 68 0x4>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0x0 0 &gic 0 68 0x4>;
+			num-lanes = <1>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			ranges = <0x00000800 0 0x80000000 0x80000000 0 0x00020000   /* configuration space */
+				0x81000000 0 0	 0x80020000 0 0x00010000   /* downstream I/O */
+				0x82000000 0 0x80030000 0xc0030000 0 0x0ffd0000>; /* non-prefetchable memory */
+			status = "disabled";
+		};
+
+		pcie1: pcie@b1800000 {
+			compatible = "st,spear1340-pcie", "snps,dw-pcie";
+			reg = <0xb1800000 0x4000>;
+			interrupts = <0 69 0x4>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0x0 0 &gic 0 69 0x4>;
+			num-lanes = <1>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			ranges = <0x00000800 0 0x90000000 0x90000000 0 0x00020000   /* configuration space */
+				0x81000000 0 0  0x90020000 0 0x00010000   /* downstream I/O */
+				0x82000000 0 0x90030000 0x90030000 0 0x0ffd0000>; /* non-prefetchable memory */
+			status = "disabled";
+		};
+
+		pcie2: pcie@b4000000 {
+			compatible = "st,spear1340-pcie", "snps,dw-pcie";
+			reg = <0xb4000000 0x4000>;
+			interrupts = <0 70 0x4>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0x0 0 &gic 0 70 0x4>;
+			num-lanes = <1>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			ranges = <0x00000800 0 0xc0000000 0xc0000000 0 0x00020000   /* configuration space */
+				0x81000000 0 0	 0xc0020000 0 0x00010000   /* downstream I/O */
+				0x82000000 0 0xc0030000 0xc0030000 0 0x0ffd0000>; /* non-prefetchable memory */
+			status = "disabled";
+		};
+
 		gmac1: eth@5c400000 {
 			compatible = "st,spear600-gmac";
 			reg = <0x5c400000 0x8000>;
diff --git a/arch/arm/boot/dts/spear1340.dtsi b/arch/arm/boot/dts/spear1340.dtsi
index b8b32c7..bc492f5 100644
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -48,6 +48,22 @@
 			status = "disabled";
 		};
 
+		pcie0: pcie@b1000000 {
+			compatible = "st,spear1340-pcie", "snps,dw-pcie";
+			reg = <0xb1000000 0x4000>;
+			interrupts = <0 68 0x4>;
+			interrupt-map-mask = <0 0 0 0>;
+			interrupt-map = <0x0 0 &gic 0 68 0x4>;
+			num-lanes = <1>;
+			#address-cells = <3>;
+			#size-cells = <2>;
+			device_type = "pci";
+			ranges = <0x00000800 0 0x80000000 0x80000000 0 0x00020000   /* configuration space */
+				0x81000000 0 0	 0x80020000 0 0x00010000   /* downstream I/O */
+				0x82000000 0 0x80030000 0xc0030000 0 0x0ffd0000>; /* non-prefetchable memory */
+			status = "disabled";
+		};
+
 		i2s-play@b2400000 {
 			compatible = "snps,designware-i2s";
 			reg = <0xb2400000 0x10000>;
-- 
1.7.0.1

