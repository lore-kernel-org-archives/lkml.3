Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3CKPil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:38:41 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:48962 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3CKPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:38:39 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 23:38:38 +0800
Message-ID: <CAPgLHd9DUb+o9YQADJYhgWoxX0767PnEBkZf_OT6R1WtNhAOKw@mail.gmail.com>
Subject: [PATCH -next] goldfish: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: yunhong.jiang@intel.com, sheng@linux.intel.com, bruce.j.beare@intel.com,
        gregkh@linuxfoundation.org, xiaohui.xin@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/platform/goldfish/pdev_bus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/goldfish/pdev_bus.c b/drivers/platform/goldfish/pdev_bus.c
index 92cc4cf..816faf0 100644
--- a/drivers/platform/goldfish/pdev_bus.c
+++ b/drivers/platform/goldfish/pdev_bus.c
@@ -91,8 +91,7 @@ static void goldfish_pdev_remove(void)
 	}
 	list_for_each_entry_safe(pos, n, &pdev_bus_registered_devices, list) {
 		if (pos->resources[0].start == base) {
-			list_del(&pos->list);
-			list_add_tail(&pos->list, &pdev_bus_removed_devices);
+			list_move_tail(&pos->list, &pdev_bus_removed_devices);
 			schedule_work(&pdev_bus_worker);
 			return;
 		}

