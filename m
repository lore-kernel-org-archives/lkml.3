Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150Ab3DPRaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:30:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48326 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879Ab3DPRaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:30:20 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH 2/2] rpmsg: fix kconfig dependencies for VIRTIO
Date: Tue, 16 Apr 2013 12:25:26 -0500
Message-ID: <1366133126-5448-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rpmsg configuration selects VIRTIO, but VIRTIO is now
subordinate to VIRTUALIZATION. RPMSG is currently selected
by OMAP_REMOTEPROC, and the dependency warning is not seen
with the fix in remoteproc config, but the kconfig menu
hierarchy dependency has to be honored nevertheless.

warning: (VIRTIO_PCI && VIRTIO_MMIO && REMOTEPROC && RPMSG) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION)
warning: (VIRTIO_PCI && VIRTIO_MMIO && REMOTEPROC && RPMSG) selects VIRTIO which has unmet direct dependencies (VIRTUALIZATION)

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/rpmsg/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
index f6e0ea6..370645c 100644
--- a/drivers/rpmsg/Kconfig
+++ b/drivers/rpmsg/Kconfig
@@ -3,6 +3,7 @@ menu "Rpmsg drivers"
 # RPMSG always gets selected by whoever wants it
 config RPMSG
 	tristate
+	select VIRTUALIZATION
 	select VIRTIO
 
 endmenu
-- 
1.8.2

