Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaFVIWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:22:47 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63111 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaFVIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:22:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/42] staging: rtl8188eu: Remove rtw_mfree2d(), wrapper for kfree()
Date: Sun, 22 Jun 2014 13:49:29 +0530
Message-Id: <1403425202-11942-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    5 -----
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index d18bdda..baaf276 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -213,7 +213,7 @@ exit:
 	kfree(efuseTbl);
 
 	if (eFuseWord)
-		rtw_mfree2d((void *)eFuseWord, EFUSE_MAX_SECTION_88E, EFUSE_MAX_WORD_UNIT, sizeof(u16));
+		kfree(eFuseWord);
 }
 
 static void efuse_read_phymap_from_txpktbuf(
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 2cd9e26..e5bfdd7 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -196,7 +196,6 @@ void _rtw_mfree(u8 *pbuf, u32 sz);
 #define rtw_mfree(pbuf, sz)		_rtw_mfree((pbuf), (sz))
 
 void *rtw_malloc2d(int h, int w, int size);
-void rtw_mfree2d(void *pbuf, int h, int w, int size);
 
 void _rtw_memcpy(void *dec, void *sour, u32 sz);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index 02144a4..92203c3 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -89,11 +89,6 @@ void *rtw_malloc2d(int h, int w, int size)
 	return a;
 }
 
-void rtw_mfree2d(void *pbuf, int h, int w, int size)
-{
-	kfree(pbuf);
-}
-
 void _rtw_init_listhead(struct list_head *list)
 {
 	INIT_LIST_HEAD(list);
-- 
1.7.10.4

