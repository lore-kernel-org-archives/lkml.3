Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3LDIVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:21:24 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10818 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521Ab3LDIVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:21:21 -0500
From: Qiao Zhou <zhouqiao@marvell.com>
To: <eric.y.miao@gmail.com>, <haojian.zhuang@gmail.com>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <chao.xie@marvell.com>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH 1/2] arm: mmp: build sram driver alone
Date: Wed, 4 Dec 2013 16:21:14 +0800
Message-ID: <1386145275-27438-2-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1386145275-27438-1-git-send-email-zhouqiao@marvell.com>
References: <1386145275-27438-1-git-send-email-zhouqiao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-12-04_03:2013-12-03,2013-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312040003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sram driver can be used by many chips besides CPU_MMP2, and so build
it alone.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
---
 arch/arm/mach-mmp/Kconfig  |    3 +++
 arch/arm/mach-mmp/Makefile |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index ebdda83..ebdba87 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -136,4 +136,7 @@ config USB_EHCI_MV_U2O
 	help
 	  Enables support for OTG controller which can be switched to host mode.
 
+config MMP_SRAM
+	bool
+
 endif
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index 9b702a1..98f0f63 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -7,7 +7,8 @@ obj-y				+= common.o devices.o time.o
 # SoC support
 obj-$(CONFIG_CPU_PXA168)	+= pxa168.o
 obj-$(CONFIG_CPU_PXA910)	+= pxa910.o
-obj-$(CONFIG_CPU_MMP2)		+= mmp2.o sram.o
+obj-$(CONFIG_CPU_MMP2)		+= mmp2.o
+obj-$(CONFIG_MMP_SRAM)		+= sram.o
 
 ifeq ($(CONFIG_COMMON_CLK), )
 obj-y				+= clock.o
-- 
1.7.0.4

