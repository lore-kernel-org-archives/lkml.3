Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaGTFcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 01:32:00 -0400
Received: from m12-13.163.com ([220.181.12.13]:57035 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaGTFb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 01:31:59 -0400
X-Coremail-DSSMTP: 180.110.162.144
From: weiyj_lk@163.com
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] power_supply: Fix sparse non static symbol warning
Date: Sun, 20 Jul 2014 13:31:09 +0800
Message-Id: <1405834269-7726-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DcCowEA5sXYnVMtTeyjvBw--.1069S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGw4DArykCr43Jw4DCFg_yoWfurgEka
	48J34xJrsYka4Skr90yFnrZFyIy3W7ZrZxXF42qFW2ya4Ygw1qywnruryUXr1UGrWDCa9r
	J3sFqr4fJFyxGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUY35r7UUUUU==
X-Originating-IP: [180.110.162.144]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiNQfO1lHZXdkPPgAAsX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/power/power_supply_core.c:540:5: warning:
 symbol '__power_supply_register' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/power/power_supply_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 5a5a24e..078afd6 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -537,7 +537,8 @@ static void psy_unregister_cooler(struct power_supply *psy)
 }
 #endif
 
-int __power_supply_register(struct device *parent, struct power_supply *psy, bool ws)
+static int __power_supply_register(struct device *parent,
+				   struct power_supply *psy, bool ws)
 {
 	struct device *dev;
 	int rc;

