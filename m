Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbaCSIU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:20:56 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56971 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006AbaCSIUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:20:50 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCH 4/5] staging: wlags49_h2: Correct macro style in wl_netdev.c
Date: Wed, 19 Mar 2014 09:20:34 +0100
Message-Id: <1395217235-2979-4-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
References: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multi statement macro should use do{}while(0)

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/wlags49_h2/wl_netdev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 255d291..6455956 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -107,9 +107,11 @@
  * macros
  ******************************************************************************/
 #define BLOCK_INPUT(buf, len) \
-    desc->buf_addr = buf; \
-    desc->BUF_SIZE = len; \
-    status = hcf_rcv_msg(&(lp->hcfCtx), desc, 0)
+	do { \
+		desc->buf_addr = buf; \
+		desc->BUF_SIZE = len; \
+		status = hcf_rcv_msg(&(lp->hcfCtx), desc, 0) \
+	} while (0)
 
 #define BLOCK_INPUT_DMA(buf, len) memcpy( buf, desc_next->buf_addr, pktlen )
 
-- 
1.9.0

