Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaLCL3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:29:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbaLCL1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:51 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Micky Ching <micky_ching@realsil.com.cn>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Dubov <oakad@yahoo.com>, Roger Tseng <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 072/101] drivers/memstick/host/rtsx_pci_ms.c: add cancel_work when remove driver
Date: Wed,  3 Dec 2014 12:26:34 +0100
Message-Id: <fed533bb941e2d3155c89bab8a43493c85bdcb56.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b6226b45c66196e14ef628d3aead2139700db1ad upstream.

Add cancel_work_sync() in rtsx_pci_ms_drv_remove() to cancel pending
request work when removing the driver.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Cc: Samuel Ortiz <sameo@linux.intel.com> says:
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Roger Tseng <rogerable@realtek.com>
Cc: Wei WANG <wei_wang@realsil.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/memstick/host/rtsx_pci_ms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index 25f8f93decb6..8d70fcf18901 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -591,6 +591,7 @@ static int rtsx_pci_ms_drv_remove(struct platform_device *pdev)
 	pcr->slots[RTSX_MS_CARD].card_event = NULL;
 	msh = host->msh;
 	host->eject = true;
+	cancel_work_sync(&host->handle_req);
 
 	mutex_lock(&host->host_mutex);
 	if (host->req) {
-- 
2.1.3

