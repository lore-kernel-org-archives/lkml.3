Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaAGMN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:13:26 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:51134 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaAGMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:38 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCHv2 5/7] vt6655: remove typedefs in wpactl.h
Date: Tue,  7 Jan 2014 13:11:49 +0100
Message-Id: <1389096711-8595-6-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>

wpactl.h contained some typedefs for enums. These were removed in this patch.
Also, a typedef for a type "unsigned long long" that was only instantiated in
one place was removed and its declaration altered.

Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/hostap.c |  2 +-
 drivers/staging/vt6655/iwctl.c  |  2 +-
 drivers/staging/vt6655/wpactl.h | 12 +++++-------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index ca54b79..6eecd53 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -454,7 +454,7 @@ static int hostap_set_encryption(PSDevice pDevice,
 	unsigned long dwKeyIndex = 0;
 	unsigned char abyKey[MAX_KEY_LEN];
 	unsigned char abySeq[MAX_KEY_LEN];
-	NDIS_802_11_KEY_RSC   KeyRSC;
+	unsigned long long KeyRSC;
 	unsigned char byKeyDecMode = KEY_CTL_WEP;
 	int     ret = 0;
 	int     iNodeIndex = -1;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 2db4bc8..ac3fc16 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -1827,7 +1827,7 @@ int iwctl_siwencodeext(struct net_device *dev,
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	struct viawget_wpa_param *param = NULL;
 //original member
-	wpa_alg alg_name;
+	enum wpa_alg alg_name;
 	u8  addr[6];
 	int key_idx, set_tx = 0;
 	u8  seq[IW_ENCODE_SEQ_MAX_SIZE];
diff --git a/drivers/staging/vt6655/wpactl.h b/drivers/staging/vt6655/wpactl.h
index b9e2ab2..f7638ba 100644
--- a/drivers/staging/vt6655/wpactl.h
+++ b/drivers/staging/vt6655/wpactl.h
@@ -38,11 +38,11 @@
 
 //WPA related
 
-typedef enum { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP } wpa_alg;
-typedef enum { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
-	       CIPHER_WEP104 } wpa_cipher;
-typedef enum { KEY_MGMT_802_1X, KEY_MGMT_CCKM, KEY_MGMT_PSK, KEY_MGMT_NONE,
-	       KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE } wpa_key_mgmt;
+enum wpa_alg { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP };
+enum wpa_cipher { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
+		  CIPHER_WEP104 };
+enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_CCKM, KEY_MGMT_PSK, KEY_MGMT_NONE,
+		    KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE };
 
 #define AUTH_ALG_OPEN_SYSTEM	0x01
 #define AUTH_ALG_SHARED_KEY	0x02
@@ -51,8 +51,6 @@ typedef enum { KEY_MGMT_802_1X, KEY_MGMT_CCKM, KEY_MGMT_PSK, KEY_MGMT_NONE,
 #define GENERIC_INFO_ELEM 0xdd
 #define RSN_INFO_ELEM 0x30
 
-typedef unsigned long long   NDIS_802_11_KEY_RSC;
-
 /*---------------------  Export Classes  ----------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
-- 
1.8.1.2

