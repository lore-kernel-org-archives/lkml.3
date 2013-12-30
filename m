Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3L3PEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:04:23 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:53039 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab3L3PDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:03:47 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH 1/7] vt6655: Remove unused macros in 80211hdr.h
Date: Mon, 30 Dec 2013 15:52:31 +0100
Message-Id: <1388415157-17615-2-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>

The file 80211hdr.h contained 4 macros (in both little and big endain fashion)
that were not used in the driver. Thus, this patch removes them.

Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/80211hdr.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/vt6655/80211hdr.h b/drivers/staging/vt6655/80211hdr.h
index ba53340..cacf137 100644
--- a/drivers/staging/vt6655/80211hdr.h
+++ b/drivers/staging/vt6655/80211hdr.h
@@ -155,17 +155,13 @@
 #ifdef __BIG_ENDIAN
 
 /* GET & SET Frame Control bit */
-#define WLAN_GET_FC_PRVER(n)    ((((unsigned short)(n) >> 8) & (BIT0 | BIT1))
 #define WLAN_GET_FC_FTYPE(n)    ((((unsigned short)(n) >> 8) & (BIT2 | BIT3)) >> 2)
 #define WLAN_GET_FC_FSTYPE(n)   ((((unsigned short)(n) >> 8) & (BIT4|BIT5|BIT6|BIT7)) >> 4)
 #define WLAN_GET_FC_TODS(n)     ((((unsigned short)(n) << 8) & (BIT8)) >> 8)
 #define WLAN_GET_FC_FROMDS(n)   ((((unsigned short)(n) << 8) & (BIT9)) >> 9)
 #define WLAN_GET_FC_MOREFRAG(n) ((((unsigned short)(n) << 8) & (BIT10)) >> 10)
-#define WLAN_GET_FC_RETRY(n)    ((((unsigned short)(n) << 8) & (BIT11)) >> 11)
 #define WLAN_GET_FC_PWRMGT(n)   ((((unsigned short)(n) << 8) & (BIT12)) >> 12)
-#define WLAN_GET_FC_MOREDATA(n) ((((unsigned short)(n) << 8) & (BIT13)) >> 13)
 #define WLAN_GET_FC_ISWEP(n)    ((((unsigned short)(n) << 8) & (BIT14)) >> 14)
-#define WLAN_GET_FC_ORDER(n)    ((((unsigned short)(n) << 8) & (BIT15)) >> 15)
 
 /* Sequence Field bit */
 #define WLAN_GET_SEQ_FRGNUM(n) (((unsigned short)(n) >> 8) & (BIT0|BIT1|BIT2|BIT3))
@@ -188,17 +184,13 @@
 #else
 
 /* GET & SET Frame Control bit */
-#define WLAN_GET_FC_PRVER(n)    (((unsigned short)(n)) & (BIT0 | BIT1))
 #define WLAN_GET_FC_FTYPE(n)    ((((unsigned short)(n)) & (BIT2 | BIT3)) >> 2)
 #define WLAN_GET_FC_FSTYPE(n)   ((((unsigned short)(n)) & (BIT4|BIT5|BIT6|BIT7)) >> 4)
 #define WLAN_GET_FC_TODS(n)     ((((unsigned short)(n)) & (BIT8)) >> 8)
 #define WLAN_GET_FC_FROMDS(n)   ((((unsigned short)(n)) & (BIT9)) >> 9)
 #define WLAN_GET_FC_MOREFRAG(n) ((((unsigned short)(n)) & (BIT10)) >> 10)
-#define WLAN_GET_FC_RETRY(n)    ((((unsigned short)(n)) & (BIT11)) >> 11)
 #define WLAN_GET_FC_PWRMGT(n)   ((((unsigned short)(n)) & (BIT12)) >> 12)
-#define WLAN_GET_FC_MOREDATA(n) ((((unsigned short)(n)) & (BIT13)) >> 13)
 #define WLAN_GET_FC_ISWEP(n)    ((((unsigned short)(n)) & (BIT14)) >> 14)
-#define WLAN_GET_FC_ORDER(n)    ((((unsigned short)(n)) & (BIT15)) >> 15)
 
 /* Sequence Field bit */
 #define WLAN_GET_SEQ_FRGNUM(n) (((unsigned short)(n)) & (BIT0|BIT1|BIT2|BIT3))
-- 
1.8.1.2

