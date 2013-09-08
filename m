Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab3IHDTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56027 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751Ab3IHDSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stanislaw Gruszka" <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.666431669@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [099/121] iwl4965: fix rfkill set state regression
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename, context, naming]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlegacy/iwl4965-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -872,9 +872,9 @@ static void iwl4965_irq_tasklet(struct i
 			set_bit(STATUS_RF_KILL_HW, &priv->status);
 		} else {
 			clear_bit(STATUS_RF_KILL_HW, &priv->status);
-			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
 			iwl_legacy_force_reset(priv, true);
 		}
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}

