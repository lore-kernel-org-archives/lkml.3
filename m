Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaL3IFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 03:05:42 -0500
Received: from m50-132.163.com ([123.125.50.132]:41900 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaL3IFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 03:05:40 -0500
From: xuyongjiande@163.com
To: shahed.shaikh@qlogic.com, Dept-GELinuxNICDev@qlogic.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yongjian Xu <xuyongjiande@gmail.com>
Subject: [PATCH] qlcnic: Fix return value in qlcnic_probe()
Date: Tue, 30 Dec 2014 16:03:46 +0800
Message-Id: <1419926626-26624-1-git-send-email-xuyongjiande@163.com>
X-Mailer: git-send-email 1.7.9.5
X-CM-TRANSID: DNGowEAJfyJtXKJU0O_5AQ--.1208S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrykZw48XryDWF4DCry5twb_yoW3tFb_G3
	WUZr18Xa1kJryqkw47trs8A34jgFnFqwn3C3WI9ay5J3srAa1UCr1DCrySqr4UW3y0vFyU
	G3Z7Aayava4IyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnOVy3UUUUU==
X-Originating-IP: [166.111.131.12]
X-CM-SenderInfo: p0x100pjmlt0lgh6il2tof0z/xtbBygVyW1O+Z2NchgAAsV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yongjian Xu <xuyongjiande@gmail.com>

If the check of adapter fails and goes into the 'else' branch, the
return value 'err' should not still be zero.

Signed-off-by: Yongjian Xu <xuyongjiande@gmail.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 1aa25b1..a95b604 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2603,6 +2603,7 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} else {
 		dev_err(&pdev->dev,
 			"%s: failed. Please Reboot\n", __func__);
+		err = -ENODEV;
 		goto err_out_free_hw;
 	}
 
-- 
1.7.9.5


