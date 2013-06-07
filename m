Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3FGLYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:24:20 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27687 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab3FGLYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:24:19 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] drivers: Select dependencies for the VIRTUALIZATION symbol
Date: Fri, 7 Jun 2013 12:23:08 +0100
Message-ID: <1370604188-19806-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_07_12_24_16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VIRTUALIZATION symbol depends on HAVE_KVM but CONFIG_REMOTEPROC
and CONFIG_RPMSG do not select HAVE_KVM leading to the following
warning and build problems later on:

warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet
direct dependencies (HAVE_KVM)
warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet
direct dependencies (HAVE_KVM)

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/Kconfig | 1 +
 drivers/rpmsg/Kconfig      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index d4d377c..79648ca 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -6,6 +6,7 @@ config REMOTEPROC
 	depends on HAS_DMA
 	select CRC32
 	select FW_LOADER
+	select HAVE_KVM
 	select VIRTIO
 	select VIRTUALIZATION
 
diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
index 69a2193..3f0bd0f 100644
--- a/drivers/rpmsg/Kconfig
+++ b/drivers/rpmsg/Kconfig
@@ -3,6 +3,7 @@ menu "Rpmsg drivers"
 # RPMSG always gets selected by whoever wants it
 config RPMSG
 	tristate
+	select HAVE_KVM
 	select VIRTIO
 	select VIRTUALIZATION
 
-- 
1.8.2.1


