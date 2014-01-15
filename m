Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaAOJRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:17:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22654 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaAOJRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:17:39 -0500
X-AuditID: cbfee690-b7f266d00000287c-6e-52d6523210b3
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: [PATCH 8/8 v4] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Wed, 15 Jan 2014 14:47:52 +0530
Message-id: <1389777472-15294-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkTtco6FqQwedb1hYvD2ladL+Ssbh/
	7yeTxeVdc9gsZpzfx2SxaNt/ZotVu/4wWpydc4jJgcNj56y77B7bDqh69G1ZxejxeZNcAEsU
	l01Kak5mWWqRvl0CV0Z/7xX2gkWcFacfLmRqYLzF3sXIySEhYCIxuWUdC4QtJnHh3nq2LkYu
	DiGBpYwSpzeegCta37CFHSKxiFFixrOpjBBOP5PEvI3vmUCq2ATMJA4uWg3WISLgLPG7eQ0r
	SBGzwBxGiYdL2sF2CAu4Skx/PIMVxGYRUJV4PO8DWJwXKH5pSydzFyMH0DoFiTmTbEDCnAJu
	EvdnvAIrEQIqeTh1AivERdPZJa7O9YUYIyDxbfIhFohWWYlNB5ghSiQlDq64wTKBUXgBI8Mq
	RtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMAAP/3v2YQdjPcOWB9iTAYaN5FZSjQ5HxgheSXx
	hsZmRhamJqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6PJ9QsF7
	41kbXcoPXQt8MX3t5ol7Dq6Lu36tfGp5tqjtkZTDh53vfVPOMhSOW7JKrY1HNaHaJWCWeI9E
	6FajhyXfolqaD528p3/Ilvv+FNYPIfJWDmfbgy7NvV31TdzgWktKHVu4qT7XW16DwrfF++z1
	apd7vz8wP6km9azRweMShQVlPxWylViKMxINtZiLihMBBMlXZIYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAV2joGtBBlP+GFu8PKRp0f1KxuL+
	vZ9MFpd3zWGzmHF+H5PFom3/mS1W7frDaHF2ziEmBw6PnbPusntsO6Dq0bdlFaPH501yASxR
	DYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBHKCmU
	JeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz+nuvsBcs4qw4/XAhUwPjLfYu
	Rk4OCQETifUNW6BsMYkL99azdTFycQgJLGKUmPFsKiOE088kMW/jeyaQKjYBM4mDi1aDdYgI
	OEv8bl7DClLELDCHUeLhknYWkISwgKvE9MczWEFsFgFVicfzPoDFeYHil7Z0MncxcgCtU5CY
	M8kGJMwp4CZxf8YrsBIhoJKHUyewTmDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OIKeSe1gXNlgcYhRgINRiYf3R/jVICHWxLLiytxDjBIczEoivFI+14KEeFMSK6tSi/Lji0pz
	UosPMSYDHTWRWUo0OR8Y3Xkl8YbGJuamxqaWJhYmZpakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C
	2cLEwSnVwMjG80jXZfnbyBNL2z+9K9RWv71oypbklXfbTJ8c7jCfrlxeuUTUq6rt60ubtCtz
	/waUhFda/ly5x898y8l2L9WIKru/9ecs2VnOGfeq7GjSnyXp7d1Z+mMCh+ZvJdFTbwLKJbP/
	PzPPq72zxi4465AQ19nscn+hIy2iwq1vdsapWHw5l7/2txJLcUaioRZzUXEiANTGDJzkAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds use of clk_prepare/clk_unprepare as
required by generic clock framework.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
Changes since v3:
None

 drivers/crypto/s5p-sss.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index f7c66c7..870e794 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -648,7 +648,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_enable(pdata->clk);
+	clk_prepare_enable(pdata->clk);
 
 	spin_lock_init(&pdata->lock);
 	pdata->ioaddr = devm_ioremap(dev, res->start,
@@ -711,7 +711,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
  err_irq:
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
@@ -731,7 +731,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
 
 	tasklet_kill(&pdata->tasklet);
 
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
-- 
1.7.9.5

