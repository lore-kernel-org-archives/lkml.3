Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab3FAJMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:12:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3FAJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:12:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2] iwlegacy: il_pm_ops is only provided for PM_SLEEP
Date: Sat, 01 Jun 2013 11:12:32 +0200
Message-ID: <23624869.gZVMHbzzA4@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAN8TOE8Y_2RMSrgMw7KwML88_1VA=QcJwuuMKEZpZCF5_dAQ=w@mail.gmail.com>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-12-git-send-email-arnd@arndb.de> <CAN8TOE8Y_2RMSrgMw7KwML88_1VA=QcJwuuMKEZpZCF5_dAQ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T2u3dMvo4m8YzAA0ipW9yRFLnRchWlh0GLD/bIYwzDH
 fOCvp2YL5L5+Vk9/e7FbxWnlOVN+7OlME9SdKBtYBeLjMj9b+l
 5JE1hnSQ0M94yxjlHaZ+uoVf/lncggnY8qM01gsyOhjXRZ5boj
 7Gkhq0LdaZoYmUQ8SOaq6HBEpjtcF+wxiQwLHKhI7xkvEMtz3V
 KHMwLhiags6D0p80W1bK+T7jNc8PfDNyH35nw7f67TVCt0ojWy
 N4ILge/nRTzBXIjtTIdSn8aJBNM+EkpR/EgSTY9zK23KQMFXXe
 mVDvKSFPiLRkYDjXsnrNcD1ze+5nUBLE7HFybAoQAkCU+PQFwr
 AEUYGTRxYDau45ZR6sCg=
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
v2: Fixed the obvious bug pointed out by Brian Norris, and actually
    build-tested the new version.

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index f8246f2..f043092 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1832,16 +1832,16 @@ u32 il_usecs_to_beacons(struct il_priv *il, u32 usec, u32 beacon_interval);
 __le32 il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,
 			  u32 beacon_interval);
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 extern const struct dev_pm_ops il_pm_ops;
 
 #define IL_LEGACY_PM_OPS	(&il_pm_ops)
 
-#else /* !CONFIG_PM */
+#else
 
 #define IL_LEGACY_PM_OPS	NULL
 
-#endif /* !CONFIG_PM */
+#endif
 
 /*****************************************************
 *  Error Handling Debugging

