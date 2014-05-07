Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaEGD6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:58:45 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47325 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaEGD6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:58:42 -0400
X-Google-Original-Message-ID: <1399435056-32386-4-git-send-email-y>
X-Google-Original-From: y
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/13] staging: rtl8188eu: Remove 'spinlock_t lock' from struct recv_priv
Date: Wed,  7 May 2014 09:27:26 +0530
Message-Id: <5369af71.23de440a.24bf.1d32@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435056-32386-1-git-send-email-y>
References: <1399435056-32386-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

Remove unused variable 'spinlock_t lock'.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c    |    2 --
 drivers/staging/rtl8188eu/include/rtw_recv.h |    1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index a065a7f..5260fe5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -63,8 +63,6 @@ int _rtw_init_recv_priv(struct recv_priv *precvpriv, struct adapter *padapter)
 
 	int	res = _SUCCESS;
 
-	spin_lock_init(&precvpriv->lock);
-
 	_rtw_init_queue(&precvpriv->free_recv_queue);
 	_rtw_init_queue(&precvpriv->recv_pending_queue);
 	_rtw_init_queue(&precvpriv->uc_swdec_pending_queue);
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index d52cfe8..68c2ad5f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -175,7 +175,6 @@ recv_thread(passive) ; returnpkt(dispatch)
 using enter_critical section to protect
 */
 struct recv_priv {
-	spinlock_t lock;
 	struct __queue free_recv_queue;
 	struct __queue recv_pending_queue;
 	struct __queue uc_swdec_pending_queue;
-- 
1.7.10.4

