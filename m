Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaFVIic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:38:32 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62758 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaFVIi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:38:27 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 27/42] staging: rtl8188eu: Use cpu_to_be32() instead of RTW_PUT_BE32()
Date: Sun, 22 Jun 2014 14:06:33 +0530
Message-Id: <1403426208-12413-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_p2p.c          |    8 +++-----
 drivers/staging/rtl8188eu/include/osdep_service.h |   10 ----------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_p2p.c b/drivers/staging/rtl8188eu/core/rtw_p2p.c
index 0840470..5bc1937 100644
--- a/drivers/staging/rtl8188eu/core/rtw_p2p.c
+++ b/drivers/staging/rtl8188eu/core/rtw_p2p.c
@@ -310,7 +310,7 @@ static void issue_p2p_provision_resp(struct wifidirect_info *pwdinfo, u8 *raddr,
 
 	wpsielen = 0;
 	/*	WPS OUI */
-	RTW_PUT_BE32(wpsie, WPSOUI);
+	*((u32 *)(wpsie+wpsielen)) = cpu_to_be32(WPSOUI);
 	wpsielen += 4;
 
 	/*	Config Method */
@@ -569,8 +569,7 @@ u32 build_probe_resp_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf)
 	p2pielen += 2;
 
 	/*	OUI */
-	/* u32*) (p2pie + p2pielen) = cpu_to_be32(WPSOUI); */
-	RTW_PUT_BE32(p2pie + p2pielen, WPSOUI);
+	*((u32 *)(p2pie + p2pielen)) = cpu_to_be32(WPSOUI);
 	p2pielen += 4;
 
 	/*	Sub Category ID */
@@ -683,8 +682,7 @@ u32 build_prov_disc_request_p2p_ie(struct wifidirect_info *pwdinfo, u8 *pbuf, u8
 	p2pielen += 2;
 
 	/*	OUI */
-	/* u32*) (p2pie + p2pielen) = cpu_to_be32(WPSOUI); */
-	RTW_PUT_BE32(p2pie + p2pielen, WPSOUI);
+	*((u32 *)(p2pie + p2pielen)) = cpu_to_be32(WPSOUI);
 	p2pielen += 4;
 
 	/*	Sub Category ID */
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 64ef9bd..30613fc 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -155,9 +155,7 @@ extern int RTW_STATUS_CODE(int error_code);
 
 #define rtw_update_mem_stat(flag, sz) do {} while (0)
 u8 *_rtw_malloc(u32 sz);
-void _rtw_mfree(u8 *pbuf, u32 sz);
 #define rtw_malloc(sz)			_rtw_malloc((sz))
-#define rtw_mfree(pbuf, sz)		_rtw_mfree((pbuf), (sz))
 
 void *rtw_malloc2d(int h, int w, int size);
 
@@ -271,14 +269,6 @@ u64 rtw_modular64(u64 x, u64 y);
 #define RTW_GET_BE24(a) ((((u32) (a)[0]) << 16) | (((u32) (a)[1]) << 8) | \
 			 ((u32) (a)[2]))
 
-#define RTW_PUT_BE32(a, val)					\
-	do {							\
-		(a)[0] = (u8) ((((u32) (val)) >> 24) & 0xff);	\
-		(a)[1] = (u8) ((((u32) (val)) >> 16) & 0xff);	\
-		(a)[2] = (u8) ((((u32) (val)) >> 8) & 0xff);	\
-		(a)[3] = (u8) (((u32) (val)) & 0xff);		\
-	} while (0)
-
 void rtw_buf_free(u8 **buf, u32 *buf_len);
 void rtw_buf_update(u8 **buf, u32 *buf_len, u8 *src, u32 src_len);
 
-- 
1.7.10.4

