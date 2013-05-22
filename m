Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3EVDyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 23:54:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:22669 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab3EVDyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 23:54:20 -0400
Message-ID: <519C40A8.1070506@huawei.com>
Date: Wed, 22 May 2013 11:51:04 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <dwmw2@infradead.org>
CC: <zajec5@gmail.com>, <artem.bityutskiy@linux.intel.com>,
        <wfp5p@virginia.edu>, <hauke@hauke-m.de>,
        <linux-mtd@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND] mtd: fix kfree bcm47xxsflash
References: <1367743225-3484-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1367743225-3484-1-git-send-email-libo.chen@huawei.com>
X-Forwarded-Message-Id: <1367743225-3484-1-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash  not its member.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Acked-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/mtd/devices/bcm47xxsflash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

* add Acked-by: Rafał Miłecki <zajec5@gmail.com>
* change send list

diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
index 9526628..4aa9141 100644
--- a/drivers/mtd/devices/bcm47xxsflash.c
+++ b/drivers/mtd/devices/bcm47xxsflash.c
@@ -76,7 +76,7 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
 	return 0;

 err_dev_reg:
-	kfree(&b47s->mtd);
+	kfree(b47s);
 out:
 	return err;
 }
-- 
1.8.1.2






