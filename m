Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaHFEmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:42:08 -0400
Received: from s87.loopia.se ([194.9.94.112]:32225 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaHFEmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:42:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 02/15] cpufreq: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:41:48 -0700
Message-Id: <1407300108-32186-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/cpufreq/speedstep-smi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index 8635eec..fda9beb 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -324,8 +324,8 @@ static int __init speedstep_init(void)
 		return -ENODEV;
 	}
 
-	pr_debug("signature:0x%.8ulx, command:0x%.8ulx, "
-		"event:0x%.8ulx, perf_level:0x%.8ulx.\n",
+	pr_debug("signature:0x%.8lx, command:0x%.8lx, "
+		"event:0x%.8lx, perf_level:0x%.8lx.\n",
 		ist_info.signature, ist_info.command,
 		ist_info.event, ist_info.perf_level);
 
-- 
2.0.0.526.g5318336

