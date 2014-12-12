Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaLLW7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:59:31 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55254 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaLLW73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:59:29 -0500
From: Krzysztof Konopko <kris@konagma.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kris@konagma.com
Subject: [PATCH] staging: rtl8723au: Fix sparse warnings
Date: Fri, 12 Dec 2014 23:58:57 +0100
Message-Id: <1418425137-13339-1-git-send-email-kris@konagma.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418336609-10191-1-git-send-email-kris@konagma.com>
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some struct fields in wifi.h are meant to be __le16 but were declared as
unsigned short.  This was reported by sparse:

  rtw_wlan_util.c:538:24: warning: cast to restricted __le16
  rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
  rtw_wlan_util.c:1546:25: warning: cast to restricted __le16

This patch changes the types of the struct fields involved to be
little-endian which is what is received over the air and consistent with
relevant structs in include/linux/ieee80211.h.

Signed-off-by: Krzysztof Konopko <kris@konagma.com>
---
 drivers/staging/rtl8723au/include/wifi.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
index fd3da3b..266c43e 100644
--- a/drivers/staging/rtl8723au/include/wifi.h
+++ b/drivers/staging/rtl8723au/include/wifi.h
@@ -28,7 +28,7 @@
 struct AC_param {
 	unsigned char		ACI_AIFSN;
 	unsigned char		CW;
-	unsigned short	TXOP_limit;
+	__le16			TXOP_limit;
 }  __packed;
 
 struct WMM_para_element {
@@ -39,9 +39,9 @@ struct WMM_para_element {
 
 struct ADDBA_request {
 	unsigned char		dialog_token;
-	unsigned short	BA_para_set;
-	unsigned short	BA_timeout_value;
-	unsigned short	BA_starting_seqctrl;
+	__le16		BA_para_set;
+	__le16		BA_timeout_value;
+	__le16		BA_starting_seqctrl;
 }  __packed;
 
 
-- 
2.1.3

