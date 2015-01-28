Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618AbbA1EPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:15:48 -0500
Received: from mail.kernel.org ([198.145.29.136]:37517 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131AbbA1EPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:15:45 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 027/177] rt2800: correct BBP1_TX_POWER_CTRL mask
Date: Wed, 28 Jan 2015 12:07:00 +0800
Message-Id: <1422418236-12852-53-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 01f7feeaf4528bec83798316b3c811701bac5d3e upstream.

Two bits control TX power on BBP_R1 register. Correct the mask,
otherwise we clear additional bit on BBP_R1 register, what can have
unknown, possible negative effect.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/wireless/rt2x00/rt2800.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 063bfa8..9105493 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1751,7 +1751,7 @@ struct mac_iveiv_entry {
  * 2 - drop tx power by 12dBm,
  * 3 - increase tx power by 6dBm
  */
-#define BBP1_TX_POWER_CTRL		FIELD8(0x07)
+#define BBP1_TX_POWER_CTRL		FIELD8(0x03)
 #define BBP1_TX_ANTENNA			FIELD8(0x18)
 
 /*
-- 
1.9.1

