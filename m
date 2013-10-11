Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab3JKLG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:06:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58453 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab3JKKmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 027/100] tg3: Expand led off fix to include 5720
Date: Fri, 11 Oct 2013 11:40:57 +0100
Message-Id: <1381488130-30235-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5e01182..18657a9 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2787,6 +2787,7 @@ static bool tg3_phy_led_bug(struct tg3 *tp)
 {
 	switch (GET_ASIC_REV(tp->pci_chip_rev_id)) {
 	case ASIC_REV_5719:
+	case ASIC_REV_5720:
 		if ((tp->phy_flags & TG3_PHYFLG_MII_SERDES) &&
 		    !tp->pci_fn)
 			return true;
-- 
1.8.3.2

