Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaHHHR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:17:59 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:59740 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976AbaHHHRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:17:55 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: support.opensource@diasemi.com, dmitry.torokhov@gmail.com
Cc: anthony.olech.opensource@diasemi.com, david.chen@diasemi.com,
        kiran.padwal21@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 1/2] Input: da9055_onkey: Remove unnecessary OOM meassage
Date: Fri,  8 Aug 2014 12:44:57 +0530
Message-Id: <1407482097-17624-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to print out-of-memory errors since this is already
done by the memory management subsystem which even calls dump_stack().

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/input/misc/da9055_onkey.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index 4765799..ed6eaa9 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -87,10 +87,8 @@ static int da9055_onkey_probe(struct platform_device *pdev)
 	}
 
 	onkey = devm_kzalloc(&pdev->dev, sizeof(*onkey), GFP_KERNEL);
-	if (!onkey) {
-		dev_err(&pdev->dev, "Failed to allocate memory\n");
+	if (!onkey)
 		return -ENOMEM;
-	}
 
 	input_dev = input_allocate_device();
 	if (!input_dev) {
-- 
1.7.9.5

