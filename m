Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbbANBLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:11:20 -0500
Received: from m12-15.163.com ([220.181.12.15]:53420 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbbANBLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:11:19 -0500
X-Coremail-DSSMTP: 117.88.247.19
From: weiyj_lk@163.com
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH] Mailbox: Fix return value check in pcc_init()
Date: Wed, 14 Jan 2015 09:10:56 +0800
Message-Id: <1421197856-15455-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowEA5YEcgwrVUtuv4Bg--.162S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4DZF4xXFykJFy7JFW8Zwb_yoWfJrX_C3
	43ZrnrZ3yq9Fsaqa12g345A3sIyF98Zr4FgFn7t3yag34rXa4fKryDZrnxJr15CayvkrWq
	kana9ryxAr17CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0fuctUUUUU==
X-Originating-IP: [117.88.247.19]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiGROB1lEAQr7ULwAAsL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function platform_create_bundle() returns
ERR_PTR() and never returns NULL. The NULL test in the return value
check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mailbox/pcc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 6dbf6fc..70576fb 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -393,9 +393,9 @@ static int __init pcc_init(void)
 	pcc_pdev = platform_create_bundle(&pcc_mbox_driver,
 			pcc_mbox_probe, NULL, 0, NULL, 0);
 
-	if (!pcc_pdev) {
+	if (IS_ERR(pcc_pdev)) {
 		pr_err("Err creating PCC platform bundle\n");
-		return -ENODEV;
+		return PTR_ERR(pcc_pdev);
 	}
 
 	return 0;

