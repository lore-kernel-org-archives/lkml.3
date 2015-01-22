Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbbAVIvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:51:52 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46065 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbbAVIvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:51:45 -0500
Date: Thu, 22 Jan 2015 09:51:50 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>
Cc: linux-acpi@vger.kernel.org, devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ACPI: Convert int to bool for variable later used int
 kernel macro
Message-ID: <20150122085150.GA14714@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/acpi/acpi_pad.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index c7b105c..82712a8 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -148,7 +148,7 @@ static unsigned int round_robin_time = 1; /* second */
 static int power_saving_thread(void *data)
 {
 	struct sched_param param = {.sched_priority = 1};
-	int do_sleep;
+	bool do_sleep;
 	unsigned int tsk_index = (unsigned long)data;
 	u64 last_jiffies = 0;
 
@@ -167,7 +167,7 @@ static int power_saving_thread(void *data)
 			round_robin_cpu(tsk_index);
 		}
 
-		do_sleep = 0;
+		do_sleep = false;
 
 		expire_time = jiffies + HZ * (100 - idle_pct) / 100;
 
@@ -202,7 +202,7 @@ static int power_saving_thread(void *data)
 			local_irq_enable();
 
 			if (time_before(expire_time, jiffies)) {
-				do_sleep = 1;
+				do_sleep = true;
 				break;
 			}
 		}
-- 
1.9.1

