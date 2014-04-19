Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaDSDro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 23:47:44 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60851 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaDSDrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 23:47:42 -0400
From: Zi Shen Lim <zlim.lnx@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] smc91x: fix compile error when SMC_DEBUG >= 2
Date: Fri, 18 Apr 2014 20:47:30 -0700
Message-Id: <1397879250-32041-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SMC_DEBUG >= 2, we hit the following compilation error:

drivers/net/ethernet/smsc/smc91x.c:85:0:
drivers/net/ethernet/smsc/smc91x.c: In function ‘smc_findirq’:
drivers/net/ethernet/smsc/smc91x.c:1784:9: error: ‘dev’ undeclared (first use in this function)
  DBG(2, dev, "%s: %s\n", CARDNAME, __func__);
         ^
Fix it by passing in the appropriate netdev pointer.

Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
---
 drivers/net/ethernet/smsc/smc91x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index d1b4dca..597909f 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -1781,7 +1781,7 @@ static int smc_findirq(struct smc_local *lp)
 	int timeout = 20;
 	unsigned long cookie;
 
-	DBG(2, dev, "%s: %s\n", CARDNAME, __func__);
+	DBG(2, lp->dev, "%s: %s\n", CARDNAME, __func__);
 
 	cookie = probe_irq_on();
 
-- 
1.9.1

