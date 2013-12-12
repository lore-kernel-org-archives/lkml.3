Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3LLEJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 23:09:49 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36900 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3LLEJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 23:09:47 -0500
From: Felipe Balbi <balbi@ti.com>
To: <davem@davemloft.net>
CC: <mugunthanvnm@ti.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/2] drivers: net: cpsw: fix dt probe for one port ethernet
Date: Wed, 11 Dec 2013 22:09:04 -0600
Message-ID: <1386821345-30555-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mugunthan V N <mugunthanvnm@ti.com>

When only one port of the two port is pinned out, then dt probe is failing
because second port phy is not found. fixing this by checking the number of
slaves and breaking the loop.

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---

both patches were taken from TI's 3.12 tree [1]
and have been tested on am335x, am437x and
dra7xx.

Mugunthan, I took the patches because I got bug reports
on v3.13-rc which these patches fix. Let me know if you
prefer to send another version of them for whatever
reason.

cheers

 drivers/net/ethernet/ti/cpsw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 7536a4c..a91f0c9 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1816,6 +1816,8 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 		}
 
 		i++;
+		if (i == data->slaves)
+			break;
 	}
 
 	return 0;
-- 
1.8.4.GIT

