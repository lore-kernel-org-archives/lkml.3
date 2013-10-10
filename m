Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3JJPuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:50:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3JJPuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 036/104] tg3: Expand led off fix to include 5720
Date: Thu, 10 Oct 2013 08:41:24 -0700
Message-Id: <1381419752-29733-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit 300cf9b93f74c3d969a0ad50bdac65416107c44c upstream.

Commit 989038e217e94161862a959e82f9a1ecf8dda152 ("tg3: Don't turn off
led on 5719 serdes port 0") added code to skip turning led off on port
0 of the 5719 since it powered down other ports. This workaround needs
to be enabled on the 5720 as well.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 0ffe6c0..79096af 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2925,6 +2925,7 @@ static bool tg3_phy_led_bug(struct tg3 *tp)
 {
 	switch (GET_ASIC_REV(tp->pci_chip_rev_id)) {
 	case ASIC_REV_5719:
+	case ASIC_REV_5720:
 		if ((tp->phy_flags & TG3_PHYFLG_MII_SERDES) &&
 		    !tp->pci_fn)
 			return true;
-- 
1.8.1.2

