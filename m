Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3INEQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:16:07 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:46296 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3INEQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:16:06 -0400
Message-ID: <5233E2E7.5050901@huawei.com>
Date: Sat, 14 Sep 2013 12:15:35 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] i5100_edac: remove .c suffix from the mod name
References: <5233E216.3030506@huawei.com>
In-Reply-To: <5233E216.3030506@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found i5100_edac driver used 'xxx_edac.c' as mod name,
but others used 'xxx_edac'. So remove .c suffix.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/edac/i5100_edac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 157b934..b50f52a 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -31,6 +31,8 @@

 #include "edac_core.h"

+#define EDAC_MOD_STR      "i5100_edac"
+
 /* register addresses */

 /* device 16, func 1 */
@@ -1117,7 +1119,7 @@ static int i5100_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mci->mtype_cap = MEM_FLAG_FB_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_SECDED;
 	mci->edac_cap = EDAC_FLAG_SECDED;
-	mci->mod_name = "i5100_edac.c";
+	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = "not versioned";
 	mci->ctl_name = "i5100";
 	mci->dev_name = pci_name(pdev);
-- 
1.8.2.2



