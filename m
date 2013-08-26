Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3HZHHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:07:04 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:18819 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3HZHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:07:01 -0400
Message-ID: <521AFE7C.9020102@huawei.com>
Date: Mon, 26 Aug 2013 15:06:36 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <anton@enomsg.org>, <dwmw2@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, <anton.vorontsov@linaro.org>,
        <cbouatmailru@gmail.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] power: max8925: fix missing of_node_put
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


decrease np device_node refcount after task completion

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/power/max8925_power.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index 0ee1e14..b4513f2 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -458,6 +458,7 @@ max8925_power_dt_init(struct platform_device *pdev)
 	of_property_read_u32(np, "fast-charge", &fast_charge);
 	of_property_read_u32(np, "no-insert-detect", &no_insert_detect);
 	of_property_read_u32(np, "no-temp-support", &no_temp_support);
+	of_node_put(np);

 	pdata->batt_detect = batt_detect;
 	pdata->fast_charge = fast_charge;
-- 
1.7.1

