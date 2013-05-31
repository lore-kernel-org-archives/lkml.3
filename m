Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3EaWXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:23:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab3EaWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 11/15] iwlegacy: il_pm_ops is only provided for PM_SLEEP
Date: Sat,  1 Jun 2013 00:22:48 +0200
Message-Id: <1370038972-2318779-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hn94O5MhwnaAnO/oz960hc+3JIGAjQe/eZW3LjqVDlh
 KYcGMLUgKCs9wuC1O9c67tdAINK9JLfKlmvtbKeeDlNowYG9Rd
 ztQNl2YLo1l26UbOyQQqecQIp9rhOEvIMy0jyAxj9b0Q3qNFaX
 SqXd/ijCEs7UIoHMU8stzWN08R84mhRhyYfqbFRTxS8PzNSQUn
 vZHPgemK/nihOhbwQxqxmens8Mm9xvF3jJCaeYMXnF8sx9qdQi
 SuqWv28Ck2R46chFeETf0cy7pY8QvKXhpPVuPUTBLbXg/VXFe5
 O/yfdKad57g3m8LIT0GAQKFU730qvYWW8eFmU76S9w5z0S77/t
 ithny5DBQh2RcdMHtQnvGo2x9DxtNn5h0agVYSOcA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure the conditionals for the declaration match the
definition, so we provide the alternative

 #else
 #define IL_LEGACY_PM_OPS NULL
 #endif

in the correct cases. As suggested by Borislav Petkov, this removes
the comments for the #else and #endif lines.

drivers/built-in.o:(.data+0x57974): undefined reference to `il_pm_ops'

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/iwlegacy/common.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index f8246f2..30dda98 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1832,14 +1832,14 @@ u32 il_usecs_to_beacons(struct il_priv *il, u32 usec, u32 beacon_interval);
 __le32 il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,
 			  u32 beacon_interval);
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 extern const struct dev_pm_ops il_pm_ops;
 
 #define IL_LEGACY_PM_OPS	(&il_pm_ops)
 
-#else /* !CONFIG_PM */
+#else
 
-#define IL_LEGACY_PM_OPS	NULL
+#define
 
 #endif /* !CONFIG_PM */
 
-- 
1.8.1.2

