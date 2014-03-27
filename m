Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbaC0OcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:32:21 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33709 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbaC0OcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:32:20 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: liodot@gmail.com, charrer@alacritech.com, gregkh@linuxfoundation.org,
        peter.p.waskiewicz.jr@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: slicoss: Fix smatch warning in slicoss.c
Date: Thu, 27 Mar 2014 20:01:01 +0530
Message-Id: <1395930661-23578-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following smatch warning:
slicoss/slicoss.c:1429 slic_cmdq_addcmdpage() error: we previously assumed 'pslic_handle' could be null

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index e27b88f..f350e60 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1422,8 +1422,7 @@ static void slic_cmdq_addcmdpage(struct adapter *adapter, u32 *page)
 		spin_lock_irqsave(&adapter->handle_lock.lock,
 				adapter->handle_lock.flags);
 		pslic_handle  =  adapter->pfree_slic_handles;
-		if (pslic_handle)
-			adapter->pfree_slic_handles = pslic_handle->next;
+		adapter->pfree_slic_handles = pslic_handle->next;
 		spin_unlock_irqrestore(&adapter->handle_lock.lock,
 				adapter->handle_lock.flags);
 		pslic_handle->type = SLIC_HANDLE_CMD;
-- 
1.7.9.5

