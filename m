Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaABRHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:07:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaABRH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:07:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ying Xue <ying.xue@windriver.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 25/91] atm: idt77252: fix dev refcnt leak
Date: Thu,  2 Jan 2014 09:04:00 -0800
Message-Id: <1388682306-30859-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

[ Upstream commit b5de4a22f157ca345cdb3575207bf46402414bc1 ]

init_card() calls dev_get_by_name() to get a network deceive. But it
doesn't decrease network device reference count after the device is
used.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/atm/idt77252.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 272f009..1bdf104 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3511,7 +3511,7 @@ static int init_card(struct atm_dev *dev)
 	tmp = dev_get_by_name(&init_net, tname);	/* jhs: was "tmp = dev_get(tname);" */
 	if (tmp) {
 		memcpy(card->atmdev->esi, tmp->dev_addr, 6);
-
+		dev_put(tmp);
 		printk("%s: ESI %pM\n", card->name, card->atmdev->esi);
 	}
 	/*
-- 
1.8.3.2

