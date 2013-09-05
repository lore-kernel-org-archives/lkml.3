Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab3IEU2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:28:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab3IEU2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 11/14] iwl4965: fix rfkill set state regression
Date: Thu,  5 Sep 2013 13:28:22 -0700
Message-Id: <20130905202615.711317335@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202614.354156084@linuxfoundation.org>
References: <20130905202614.354156084@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4415,9 +4415,9 @@ il4965_irq_tasklet(struct il_priv *il)
 			set_bit(S_RFKILL, &il->status);
 		} else {
 			clear_bit(S_RFKILL, &il->status);
-			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 			il_force_reset(il, true);
 		}
+		wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}


