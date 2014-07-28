Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaG1RnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:43:11 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44912 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaG1RnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:43:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 9/9] staging:rtl8188eu:Remove wrapper function _rtw_reordering_ctrl_timeout_handler()
Date: Mon, 28 Jul 2014 23:11:30 +0530
Message-Id: <1406569290-19943-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
References: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/recv_linux.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index f7d53dd..05427c4 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -191,17 +191,9 @@ _recv_indicatepkt_drop:
 	 return _FAIL;
 }
 
-static void _rtw_reordering_ctrl_timeout_handler(void *func_context)
-{
-	struct recv_reorder_ctrl *preorder_ctrl;
-
-	preorder_ctrl = (struct recv_reorder_ctrl *)func_context;
-	rtw_reordering_ctrl_timeout_handler(preorder_ctrl);
-}
-
 void rtw_init_recv_timer(struct recv_reorder_ctrl *preorder_ctrl)
 {
 	struct adapter *padapter = preorder_ctrl->padapter;
 
-	_init_timer(&(preorder_ctrl->reordering_ctrl_timer), padapter->pnetdev, _rtw_reordering_ctrl_timeout_handler, preorder_ctrl);
+	_init_timer(&(preorder_ctrl->reordering_ctrl_timer), padapter->pnetdev, rtw_reordering_ctrl_timeout_handler, preorder_ctrl);
 }
-- 
1.7.10.4

