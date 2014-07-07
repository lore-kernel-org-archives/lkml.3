Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaGGSmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:42:36 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59456 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaGGSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:42:33 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/13] staging: rtl8188eu: Remove unused function rtw_cbuf_alloc()
Date: Tue,  8 Jul 2014 00:10:11 +0530
Message-Id: <1404758413-12859-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
References: <1404758413-12859-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   21 ---------------------
 2 files changed, 22 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 238930c..2a20fca 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -199,6 +199,5 @@ bool rtw_cbuf_full(struct rtw_cbuf *cbuf);
 bool rtw_cbuf_empty(struct rtw_cbuf *cbuf);
 bool rtw_cbuf_push(struct rtw_cbuf *cbuf, void *buf);
 void *rtw_cbuf_pop(struct rtw_cbuf *cbuf);
-struct rtw_cbuf *rtw_cbuf_alloc(u32 size);
 
 #endif
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index db6ee31..f54cf52 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -228,24 +228,3 @@ void *rtw_cbuf_pop(struct rtw_cbuf *cbuf)
 
 	return buf;
 }
-
-/**
- * rtw_cbuf_alloc - allocate a rtw_cbuf with given size and do initialization
- * @size: size of pointer
- *
- * Returns: pointer of srtuct rtw_cbuf, NULL for allocation failure
- */
-struct rtw_cbuf *rtw_cbuf_alloc(u32 size)
-{
-	struct rtw_cbuf *cbuf;
-
-	cbuf = (struct rtw_cbuf *)rtw_malloc(sizeof(*cbuf) +
-	       sizeof(void *)*size);
-
-	if (cbuf) {
-		cbuf->write = 0;
-		cbuf->read = 0;
-		cbuf->size = size;
-	}
-	return cbuf;
-}
-- 
1.7.10.4

