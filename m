Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3IIStO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:49:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3IISpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 06/24] iwl4965: fix rfkill set state regression
Date: Mon,  9 Sep 2013 11:44:56 -0700
Message-Id: <1378752314-2416-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit b2fcc0aee58a3435566dd6d8501a0b355552f28b upstream.

My current 3.11 fix:

commit 788f7a56fce1bcb2067b62b851a086fca48a0056
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Aug 1 12:07:55 2013 +0200

    iwl4965: reset firmware after rfkill off

broke rfkill notification to user-space . I missed that bug, because
I compiled without CONFIG_RFKILL, sorry about that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index fdab4fc..0c63fa8 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4417,9 +4417,9 @@ il4965_irq_tasklet(struct il_priv *il)
 			set_bit(S_RFKILL, &il->status);
 		} else {
 			clear_bit(S_RFKILL, &il->status);
-			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 			il_force_reset(il, true);
 		}
+		wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
-- 
1.8.1.2

