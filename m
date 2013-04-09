Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936615Ab3DIBXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:23:08 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38279 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936057Ab3DIBXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:23:06 -0400
Date: Tue, 9 Apr 2013 09:22:40 +0800
From: Wang YanQing <udknight@gmail.com>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH][TRIVIAL] tg3: Fix compilation warning
Message-ID: <20130409012240.GA4684@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, jkosina@suse.cz,
	linux-kernel@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the below compilation warning:
linux/drivers/net/ethernet/broadcom/tg3.c: In function 'tg3_hwclock_to_timestamp':
linux/drivers/net/ethernet/broadcom/tg3.c:5686: warning: integer constant is too large for 'long' type

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index d330e81..6ec480a 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -774,7 +774,7 @@
 #define  SG_DIG_AUTONEG_ERROR		 0x00000001
 #define TG3_TX_TSTAMP_LSB		0x000005c0
 #define TG3_TX_TSTAMP_MSB		0x000005c4
-#define  TG3_TSTAMP_MASK		 0x7fffffffffffffff
+#define  TG3_TSTAMP_MASK		 0x7fffffffffffffffULL
 /* 0x5c8 --> 0x600 unused */
 #define MAC_TX_MAC_STATE_BASE		0x00000600 /* 16 bytes */
 #define MAC_RX_MAC_STATE_BASE		0x00000610 /* 20 bytes */
-- 
1.7.12.4.dirty
