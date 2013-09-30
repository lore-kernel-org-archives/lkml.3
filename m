Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3I3N2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:28:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55691 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3I3N04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:56 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d7-52497c1fe7e1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 08/14] skd: remove redundant skdev->pdev assignment from
 skd_pci_probe()
Date: Mon, 30 Sep 2013 15:25:49 +0200
Message-id: <1380547556-17719-9-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xgK58jWeQQdM/dYvenpPsFqvv9rNZ
	bJyxntXi7K+rLBZnm96wW1zeNYfNgc3j8tlSj/f7rrJ59G1Zxehx59wHJo/Pm+QCWKO4bFJS
	czLLUov07RK4Mv5ev8RUMIu9Yt/hz2wNjK1sXYwcHBICJhKLzyR3MXICmWISF+6tBwpzcQgJ
	LGKUeLughxHC6WKS+D5lDytIFZuAlcTE9lWMILaIgLDE/o5WFpAiZoEmRomNS+awgSSEBaIk
	LixaywxiswioSry+3wZm8wp4SKx6d4cRYp28xNP7fWD1nAKeEv9vHwWLCwHVfDt0mWkCI+8C
	RoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGh9ExqB+PKBotDjAIcjEo8vBOWewQJsSaW
	FVfmHmKU4GBWEuEVL/MMEuJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1
	CCbLxMEp1cCYrRL73XSt3uGnE0uE0o1L8xX0s9g5O0/t+OQfsn5mCef5rt+aqwQkstR/Gsw7
	slrd7cecBTPPVYfMtL1q+4j3oMWMw/3W3sGa5696CaX3q1X/8/jYP29q/E2LxJub9prVLHj2
	Suflw2dfZ7zV+eGn1p2iwDzh4pHt9SJMb3dd2fRaWKUg+2qJEktxRqKhFnNRcSIAJ/fTBCEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

skdev->pdev is set to pdev twice in skd_pci_probe(), first time
through skd_construct() call and the second time directly in
the function. Remove the second assignment as it is not needed.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index e003137..9fe910d 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5239,7 +5239,7 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 
 	pci_set_drvdata(pdev, skdev);
-	skdev->pdev = pdev;
+
 	skdev->disk->driverfs_dev = &pdev->dev;
 
 	for (i = 0; i < SKD_MAX_BARS; i++) {
-- 
1.8.2.3

