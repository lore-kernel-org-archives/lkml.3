Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaAGMNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:13:07 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:45477 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbaAGMMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:37 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCHv2 1/7] vt6655: balance faulty parentheses in 80211hdr.h
Date: Tue,  7 Jan 2014 13:11:45 +0100
Message-Id: <1389096711-8595-2-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>

The file 80211hdr.h contained the macro WLAN_GET_FC_PRVER(n). The big endian
fashion of this macro had unbalanced parentheses. This patch removes the
parentheses in question.

Signed-off-by: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
Signed-off-by: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
---
 drivers/staging/vt6655/80211hdr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/80211hdr.h b/drivers/staging/vt6655/80211hdr.h
index ba53340..ba155cd 100644
--- a/drivers/staging/vt6655/80211hdr.h
+++ b/drivers/staging/vt6655/80211hdr.h
@@ -155,7 +155,7 @@
 #ifdef __BIG_ENDIAN
 
 /* GET & SET Frame Control bit */
-#define WLAN_GET_FC_PRVER(n)    ((((unsigned short)(n) >> 8) & (BIT0 | BIT1))
+#define WLAN_GET_FC_PRVER(n)    (((unsigned short)(n) >> 8) & (BIT0 | BIT1))
 #define WLAN_GET_FC_FTYPE(n)    ((((unsigned short)(n) >> 8) & (BIT2 | BIT3)) >> 2)
 #define WLAN_GET_FC_FSTYPE(n)   ((((unsigned short)(n) >> 8) & (BIT4|BIT5|BIT6|BIT7)) >> 4)
 #define WLAN_GET_FC_TODS(n)     ((((unsigned short)(n) << 8) & (BIT8)) >> 8)
-- 
1.8.1.2

