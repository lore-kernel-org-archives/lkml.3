Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaGGSmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:42:43 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47263 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaGGSml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:42:41 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/13] staging: rtl8188eu: Remove unused functions rtw_cbuf_[full, empty, push, pop]()
Date: Tue,  8 Jul 2014 00:10:12 +0530
Message-Id: <1404758413-12859-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    6 --
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   65 ---------------------
 2 files changed, 71 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 2a20fca..3a620f8 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -194,10 +194,4 @@ struct rtw_cbuf {
 	u32 size;
 	void *bufs[0];
 };
-
-bool rtw_cbuf_full(struct rtw_cbuf *cbuf);
-bool rtw_cbuf_empty(struct rtw_cbuf *cbuf);
-bool rtw_cbuf_push(struct rtw_cbuf *cbuf, void *buf);
-void *rtw_cbuf_pop(struct rtw_cbuf *cbuf);
-
 #endif
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index f54cf52..8af4a8d 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -163,68 +163,3 @@ keep_ori:
 	/* free ori */
 	kfree(ori);
 }
-
-
-/**
- * rtw_cbuf_full - test if cbuf is full
- * @cbuf: pointer of struct rtw_cbuf
- *
- * Returns: true if cbuf is full
- */
-inline bool rtw_cbuf_full(struct rtw_cbuf *cbuf)
-{
-	return (cbuf->write == cbuf->read-1) ? true : false;
-}
-
-/**
- * rtw_cbuf_empty - test if cbuf is empty
- * @cbuf: pointer of struct rtw_cbuf
- *
- * Returns: true if cbuf is empty
- */
-inline bool rtw_cbuf_empty(struct rtw_cbuf *cbuf)
-{
-	return (cbuf->write == cbuf->read) ? true : false;
-}
-
-/**
- * rtw_cbuf_push - push a pointer into cbuf
- * @cbuf: pointer of struct rtw_cbuf
- * @buf: pointer to push in
- *
- * Lock free operation, be careful of the use scheme
- * Returns: true push success
- */
-bool rtw_cbuf_push(struct rtw_cbuf *cbuf, void *buf)
-{
-	if (rtw_cbuf_full(cbuf))
-		return _FAIL;
-
-	if (0)
-		DBG_88E("%s on %u\n", __func__, cbuf->write);
-	cbuf->bufs[cbuf->write] = buf;
-	cbuf->write = (cbuf->write+1)%cbuf->size;
-
-	return _SUCCESS;
-}
-
-/**
- * rtw_cbuf_pop - pop a pointer from cbuf
- * @cbuf: pointer of struct rtw_cbuf
- *
- * Lock free operation, be careful of the use scheme
- * Returns: pointer popped out
- */
-void *rtw_cbuf_pop(struct rtw_cbuf *cbuf)
-{
-	void *buf;
-	if (rtw_cbuf_empty(cbuf))
-		return NULL;
-
-	if (0)
-		DBG_88E("%s on %u\n", __func__, cbuf->read);
-	buf = cbuf->bufs[cbuf->read];
-	cbuf->read = (cbuf->read+1)%cbuf->size;
-
-	return buf;
-}
-- 
1.7.10.4

