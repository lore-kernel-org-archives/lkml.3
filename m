Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3EBPRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:17:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3EBPRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:17:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH, RFC 11/22] iwlegacy: il_pm_ops is only provided for PM_SLEEP
Date: Thu,  2 May 2013 17:16:15 +0200
Message-Id: <1367507786-505303-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:w/C9krOopA1fxEq+3Rgmob2t3PJYgVF//iumj3BjiyS
 KH3q5fxUCXsyqrqnJL4ejB3G+pXtRkmb962QY/DhlaOEElFgyR
 Uz8wrXBJMBuUbKy0ASkOp6Tkkk6F1hWU1uoF6gOoiJ27d3Srp7
 1BHXxKySbDowB9i7EdGCFiX4+Dh2OHItLb5YFaPQ2JwGYoHGMk
 PUxcgYxoIQx+nG7gY6TWABgaEk3SAobISMPn0QgPreehqCZcRc
 dATt+DRK0QShHCF9BWowp1OK4iAGFwGWwKgY/19cNrOjjwFOxi
 YQuOQwFbDL/MiGxp38gT4YRDr0Q+j3iZ4mA6n/XByHqcBKwRWh
 KLPNDhx7dTjwcz24+8nZY5OcdLP90MCfknHAqdUts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure the conditionals for the declaration match the
definition, so we provide the alternative

 #else
 #define IL_LEGACY_PM_OPS NULL
 #endif

in the correct cases.

drivers/built-in.o:(.data+0x57974): undefined reference to `il_pm_ops'

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/iwlegacy/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index f8246f2..734f1b4 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1832,7 +1832,7 @@ u32 il_usecs_to_beacons(struct il_priv *il, u32 usec, u32 beacon_interval);
 __le32 il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,
 			  u32 beacon_interval);
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 extern const struct dev_pm_ops il_pm_ops;
 
 #define IL_LEGACY_PM_OPS	(&il_pm_ops)
-- 
1.8.1.2

