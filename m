Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaFECaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:30:07 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:56416 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaFECaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:30:06 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s552TiTY022213, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <oakad@yahoo.com>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] memorystick: rtsx: add cancel_work when remove driver
Date: Thu, 5 Jun 2014 10:34:24 +0800
Message-ID: <1401935664-9111-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add cancel_work_sync() in rtsx_pci_ms_drv_remove(). Using
cancel_work_sync() to cancel pending request handle work when remove
driver.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/memstick/host/rtsx_pci_ms.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index 2a635b6..c880ba6 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -601,6 +601,7 @@ static int rtsx_pci_ms_drv_remove(struct platform_device *pdev)
 	pcr->slots[RTSX_MS_CARD].card_event = NULL;
 	msh = host->msh;
 	host->eject = true;
+	cancel_work_sync(&host->handle_req);
 
 	mutex_lock(&host->host_mutex);
 	if (host->req) {
-- 
1.7.9.5

