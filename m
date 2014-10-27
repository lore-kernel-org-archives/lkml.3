Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaJ0TW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:22:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaJ0TCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:02:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 052/105] rt2800: correct BBP1_TX_POWER_CTRL mask
Date: Mon, 27 Oct 2014 11:56:27 -0700
Message-Id: <1414436240-13879-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 01f7feeaf4528bec83798316b3c811701bac5d3e upstream.

Two bits control TX power on BBP_R1 register. Correct the mask,
otherwise we clear additional bit on BBP_R1 register, what can have
unknown, possible negative effect.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index aab6b5e..6b1e2cc 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2041,7 +2041,7 @@ struct mac_iveiv_entry {
  * 2 - drop tx power by 12dBm,
  * 3 - increase tx power by 6dBm
  */
-#define BBP1_TX_POWER_CTRL		FIELD8(0x07)
+#define BBP1_TX_POWER_CTRL		FIELD8(0x03)
 #define BBP1_TX_ANTENNA			FIELD8(0x18)
 
 /*
-- 
1.9.1

