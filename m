Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3L2C6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:58:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55083 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab3L2CJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ying Xue" <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.48507577@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 164/185] atm: idt77252: fix dev refcnt leak
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

[ Upstream commit b5de4a22f157ca345cdb3575207bf46402414bc1 ]

init_card() calls dev_get_by_name() to get a network deceive. But it
doesn't decrease network device reference count after the device is
used.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/atm/idt77252.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 1c05212..b0e75ce 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3513,7 +3513,7 @@ init_card(struct atm_dev *dev)
 	tmp = dev_get_by_name(&init_net, tname);	/* jhs: was "tmp = dev_get(tname);" */
 	if (tmp) {
 		memcpy(card->atmdev->esi, tmp->dev_addr, 6);
-
+		dev_put(tmp);
 		printk("%s: ESI %pM\n", card->name, card->atmdev->esi);
 	}
 	/*

