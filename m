Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaL3MZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:25:26 -0500
Received: from www.osadl.org ([62.245.132.105]:51071 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaL3MZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:25:24 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
        Ben Greear <greearb@candelatech.com>,
        Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        Yanbo Li <yanbol@qti.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 2/4] ath10k: fixup wait_for_completion_timeout return handling
Date: Tue, 30 Dec 2014 07:20:44 -0500
Message-Id: <1419942046-17985-3-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1419942046-17985-1-git-send-email-der.herr@hofr.at>
References: <1419942046-17985-1-git-send-email-der.herr@hofr.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_for_completion_timeout does not return negative values so
"ret" handling here should check for timeout only.

patch was only compile tested for x86_64_defconfig + CONFIG_ATH10K=m

patch is against linux-next 3.19.0-rc1 -next-20141226

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c400567..f9d7dbb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2151,7 +2151,7 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 
 		ret = wait_for_completion_timeout(&ar->offchan_tx_completed,
 						  3 * HZ);
-		if (ret <= 0)
+		if (ret == 0)
 			ath10k_warn(ar, "timed out waiting for offchannel skb %p\n",
 				    skb);
 
-- 
1.7.10.4

