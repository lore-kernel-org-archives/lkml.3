Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaEGD6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 23:58:23 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41263 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbaEGD6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 23:58:19 -0400
X-Google-Original-Message-ID: <1399435056-32386-2-git-send-email-y>
X-Google-Original-From: y
From: navin.patidar@gmail.com
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/13] staging: rtl8188eu: Remove 'semaphore allrxreturnevt' from struct recv_priv
Date: Wed,  7 May 2014 09:27:24 +0530
Message-Id: <5369af5a.c3bf440a.5e98.1d6d@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435056-32386-1-git-send-email-y>
References: <1399435056-32386-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navin patidar <navin.patidar@gmail.com>

Remove unused variable 'semaphore allrxreturnevt'.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c    |    2 --
 drivers/staging/rtl8188eu/include/rtw_recv.h |    1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index da26fa5c..a065a7f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -101,8 +101,6 @@ int _rtw_init_recv_priv(struct recv_priv *precvpriv, struct adapter *padapter)
 	}
 	precvpriv->rx_pending_cnt = 1;
 
-	sema_init(&precvpriv->allrxreturnevt, 0);
-
 	res = rtw_hal_init_recv_priv(padapter);
 
 	_init_timer(&precvpriv->signal_stat_timer, padapter->pnetdev, RTW_TIMER_HDL_NAME(signal_stat), padapter);
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 971dd16..5b3bf29 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -193,7 +193,6 @@ struct recv_priv {
 	uint  rx_largepacket_crcerr;
 	uint  rx_smallpacket_crcerr;
 	uint  rx_middlepacket_crcerr;
-	struct semaphore allrxreturnevt;
 	uint	ff_hwaddr;
 	u8	rx_pending_cnt;
 
-- 
1.7.10.4

