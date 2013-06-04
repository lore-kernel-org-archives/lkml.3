Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3FDHIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:08:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15447 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3FDHIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:08:32 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>
Subject: [RESEND][PATCH] net: wireless: iwlegacy: fix build error for il_pm_ops
Date: Tue, 4 Jun 2013 15:07:12 +0800
Message-ID: <1370329632-3556-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error for il_pm_ops if CONFIG_PM is set
but CONFIG_PM_SLEEP is not set.

ERROR: "il_pm_ops" [drivers/net/wireless/iwlegacy/iwl4965.ko] undefined!
ERROR: "il_pm_ops" [drivers/net/wireless/iwlegacy/iwl3945.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/iwlegacy/common.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index f8246f2..4caaf52 100644
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
+#else /* !CONFIG_PM_SLEEP */
 
 #define IL_LEGACY_PM_OPS	NULL
 
-#endif /* !CONFIG_PM */
+#endif /* !CONFIG_PM_SLEEP */
 
 /*****************************************************
 *  Error Handling Debugging
-- 
1.7.1


