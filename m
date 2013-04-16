Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137Ab3DPRaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:30:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48315 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965064Ab3DPRaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:30:06 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH 1/2] remoteproc: fix kconfig dependencies for VIRTIO
Date: Tue, 16 Apr 2013 12:25:11 -0500
Message-ID: <1366133111-5412-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remoteproc configuration selects VIRTIO, but VIRTIO is now
subordinate to VIRTUALIZATION. VIRTUALIZATION has to be
selected as well to honor the kconfig menu hierarchy and fix
the dependency warnings.

warning: (VIRTIO_PCI && VIRTIO_MMIO && REMOTEPROC && RPMSG) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION)
warning: (VIRTIO_PCI && VIRTIO_MMIO && REMOTEPROC && RPMSG) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION)

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/remoteproc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index c6d77e2..e5f6183 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -5,6 +5,7 @@ config REMOTEPROC
 	tristate
 	depends on HAS_DMA
 	select FW_LOADER
+	select VIRTUALIZATION
 	select VIRTIO
 
 config OMAP_REMOTEPROC
-- 
1.8.2

