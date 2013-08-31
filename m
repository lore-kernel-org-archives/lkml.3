Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3HaGpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:45:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:34222 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab3HaGpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:45:46 -0400
Message-ID: <522190ED.6020909@huawei.com>
Date: Sat, 31 Aug 2013 14:45:01 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <dmitry.torokhov@gmail.com>
CC: <peter.ujfalusi@ti.com>, Bill Pemberton <wfp5p@virginia.edu>,
        <broonie@opensource.wolfsonmicro.com>, <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] driver: input: twl4030-vibra: fix missing of_node_put
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


decrease node device_node refcount after task completion

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/input/misc/twl4030-vibra.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 68a5f33..b8d1526 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -185,8 +185,10 @@ static bool twl4030_vibra_check_coexist(struct twl4030_vibra_data *pdata,
 	if (pdata && pdata->coexist)
 		return true;

-	if (of_find_node_by_name(node, "codec"))
+	if (of_find_node_by_name(node, "codec")) {
+		of_node_put(node);
 		return true;
+	}

 	return false;
 }
-- 
1.7.1

