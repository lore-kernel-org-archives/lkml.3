Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaJAPEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:04:49 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:65283 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaJAPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:04:48 -0400
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nitin Kuppelur <nitinkuppelur@gmail.com>
Subject: [PATCH] Staging: rtl8712:ieee80211 remove unnecessary else
Date: Wed,  1 Oct 2014 17:04:27 +0200
Message-Id: <1412175867-29446-1-git-send-email-nitinkuppelur@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary else after return/break to solve
checkpatch.pl warning

Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
---
 drivers/staging/rtl8712/ieee80211.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8712/ieee80211.c b/drivers/staging/rtl8712/ieee80211.c
index fe9459e..eb23b08 100644
--- a/drivers/staging/rtl8712/ieee80211.c
+++ b/drivers/staging/rtl8712/ieee80211.c
@@ -124,11 +124,10 @@ u8 *r8712_get_ie(u8 *pbuf, sint index, sint *len, sint limit)
 		if (*p == index) {
 			*len = *(p + 1);
 			return p;
-		} else {
-			tmp = *(p + 1);
-			p += (tmp + 2);
-			i += (tmp + 2);
 		}
+		tmp = *(p + 1);
+		p += (tmp + 2);
+		i += (tmp + 2);
 		if (i >= limit)
 			break;
 	}
@@ -237,10 +236,9 @@ unsigned char *r8712_get_wpa_ie(unsigned char *pie, int *wpa_ie_len, int limit)
 				goto check_next_ie;
 			*wpa_ie_len = *(pbuf + 1);
 			return pbuf;
-		} else {
-			*wpa_ie_len = 0;
-			return NULL;
 		}
+		*wpa_ie_len = 0;
+		return NULL;
 check_next_ie:
 		limit = limit - (pbuf - pie) - 2 - len;
 		if (limit <= 0)
@@ -414,7 +412,7 @@ int r8712_get_wps_ie(u8 *in_ie, uint in_len, u8 *wps_ie, uint *wps_ielen)
 			cnt += in_ie[cnt+1]+2;
 			match = true;
 			break;
-		} else
+		}
 			cnt += in_ie[cnt+1]+2; /* goto next */
 	}
 	return match;
-- 
1.9.1

