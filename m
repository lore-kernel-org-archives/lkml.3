Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422852AbaJaCON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:14:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63713 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161714AbaJaCMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:12:24 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 12/13] arm: mmp: Make all the dts file to be compiled by Makefile
Date: Fri, 31 Oct 2014 10:13:52 +0800
Message-ID: <1414721633-29508-13-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
References: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-31_02:2014-10-30,2014-10-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410310021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

Add items in arch/arm/boot/dt/Makefile to compile the dtb
for mach-mmp.
Change the dts and dtsi file to use #include instead of \include\

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/boot/dts/Makefile            | 3 +++
 arch/arm/boot/dts/mmp2-brownstone.dts | 2 +-
 arch/arm/boot/dts/mmp2.dtsi           | 2 +-
 arch/arm/boot/dts/pxa168-aspenite.dts | 2 +-
 arch/arm/boot/dts/pxa168.dtsi         | 2 +-
 arch/arm/boot/dts/pxa910-dkb.dts      | 2 +-
 arch/arm/boot/dts/pxa910.dtsi         | 2 +-
 7 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b8c5cd3..f8f7613 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -159,6 +159,9 @@ dtb-$(CONFIG_MACH_KIRKWOOD) += kirkwood-b3.dtb \
 	kirkwood-ts419-6282.dtb
 dtb-$(CONFIG_ARCH_LPC32XX) += ea3250.dtb phy3250.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
+dtb-$(CONFIG_ARCH_MMP) += pxa168-aspenite.dtb \
+	pxa910-dkb.dtb \
+	mmp2-brownstone.dtb
 dtb-$(CONFIG_ARCH_MOXART) += moxart-uc7112lx.dtb
 dtb-$(CONFIG_ARCH_MXC) += \
 	imx25-eukrea-mbimxsd25-baseboard.dtb \
diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
index 7f70a39..350208c 100644
--- a/arch/arm/boot/dts/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/mmp2-brownstone.dts
@@ -8,7 +8,7 @@
  */
 
 /dts-v1/;
-/include/ "mmp2.dtsi"
+#include "mmp2.dtsi"
 
 / {
 	model = "Marvell MMP2 Brownstone Development Board";
diff --git a/arch/arm/boot/dts/mmp2.dtsi b/arch/arm/boot/dts/mmp2.dtsi
index 4e8b08c..e44f996 100644
--- a/arch/arm/boot/dts/mmp2.dtsi
+++ b/arch/arm/boot/dts/mmp2.dtsi
@@ -7,7 +7,7 @@
  *  publishhed by the Free Software Foundation.
  */
 
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	aliases {
diff --git a/arch/arm/boot/dts/pxa168-aspenite.dts b/arch/arm/boot/dts/pxa168-aspenite.dts
index e762fac..0a988b3 100644
--- a/arch/arm/boot/dts/pxa168-aspenite.dts
+++ b/arch/arm/boot/dts/pxa168-aspenite.dts
@@ -8,7 +8,7 @@
  */
 
 /dts-v1/;
-/include/ "pxa168.dtsi"
+#include "pxa168.dtsi"
 
 / {
 	model = "Marvell PXA168 Aspenite Development Board";
diff --git a/arch/arm/boot/dts/pxa168.dtsi b/arch/arm/boot/dts/pxa168.dtsi
index 975dad2..bfcbdef 100644
--- a/arch/arm/boot/dts/pxa168.dtsi
+++ b/arch/arm/boot/dts/pxa168.dtsi
@@ -7,7 +7,7 @@
  *  publishhed by the Free Software Foundation.
  */
 
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	aliases {
diff --git a/arch/arm/boot/dts/pxa910-dkb.dts b/arch/arm/boot/dts/pxa910-dkb.dts
index 595492a..c82f281 100644
--- a/arch/arm/boot/dts/pxa910-dkb.dts
+++ b/arch/arm/boot/dts/pxa910-dkb.dts
@@ -8,7 +8,7 @@
  */
 
 /dts-v1/;
-/include/ "pxa910.dtsi"
+#include "pxa910.dtsi"
 
 / {
 	model = "Marvell PXA910 DKB Development Board";
diff --git a/arch/arm/boot/dts/pxa910.dtsi b/arch/arm/boot/dts/pxa910.dtsi
index 0247c62..884c6e8 100644
--- a/arch/arm/boot/dts/pxa910.dtsi
+++ b/arch/arm/boot/dts/pxa910.dtsi
@@ -7,7 +7,7 @@
  *  publishhed by the Free Software Foundation.
  */
 
-/include/ "skeleton.dtsi"
+#include "skeleton.dtsi"
 
 / {
 	aliases {
-- 
1.8.3.2

