Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3KELiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:38:01 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47653 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3KELh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:37:57 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-4f-5278d8942eb1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 07/11] skd: remove redundant skdev->pdev assignment from
 skd_pci_probe()
Date: Tue, 05 Nov 2013 12:37:05 +0100
Message-id: <1383651429-4322-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO6UGxVBBpNadSx6e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgyri9+TlzwWz2iuVvpjM2MLaxdTFyckgImEjsWzqPHcIWk7hwbz1QnItDSGA6
	o8T3dbeYIZwuJonNiyawglSxCVhJTGxfxQhiiwgIS+zvaGUBKWIWWMAoMXnHHLBRwgKxEr87
	3oAVsQioSuzcfRQozsHBK+Au8eJsJMQ2eYmn9/vAruAU8JC4cukNWKsQUMm2j3tZJzDyLmBk
	WMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHErPpHYwrmywOMQowMGoxMP74Gx5kBBrYllx
	Ze4hRgkOZiUR3rYjFUFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbB
	ZJk4OKUaGJ04Lz0SDT9yeY4BX1DV7nX6PyUFH/isbr6ZOoe76LfE1tllR6sPzfTpi5S3LU9k
	adaZeSJJdZfl1zmsrYZJglf1Nl5/vq1kRn3agwsd13fuj/Tj/XC2+/OMqQIL59VcDX8wg+Ph
	m00/b7Bc9WXXDKivrN3RxOR78/y1ORInX6Xnbvgw2WwWG4cSS3FGoqEWc1FxIgC9qls8IQIA	AA==
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
index e3dfd0da..70118a1 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4925,7 +4925,7 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 
 	pci_set_drvdata(pdev, skdev);
-	skdev->pdev = pdev;
+
 	skdev->disk->driverfs_dev = &pdev->dev;
 
 	for (i = 0; i < SKD_MAX_BARS; i++) {
-- 
1.8.2.3

