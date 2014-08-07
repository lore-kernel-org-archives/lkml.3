Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbaHGFxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:53:47 -0400
Received: from s87.loopia.se ([194.9.94.112]:13058 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbaHGFxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:53:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 1/1] cpufreq: fix decimal printf specifiers prefixed with 0x
Date: Wed,  6 Aug 2014 22:52:23 -0700
Message-Id: <1407390743-30085-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1494298.av10nJMuYA@vostro.rjw.lan>
References: <1494298.av10nJMuYA@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that. Also, these are 32-bit values,
so drop the l characters.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/cpufreq/speedstep-smi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index 8635eec..5fc96d5 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -324,8 +324,8 @@ static int __init speedstep_init(void)
 		return -ENODEV;
 	}
 
-	pr_debug("signature:0x%.8ulx, command:0x%.8ulx, "
-		"event:0x%.8ulx, perf_level:0x%.8ulx.\n",
+	pr_debug("signature:0x%.8x, command:0x%.8x, "
+		"event:0x%.8x, perf_level:0x%.8x.\n",
 		ist_info.signature, ist_info.command,
 		ist_info.event, ist_info.perf_level);
 
-- 
2.0.0.526.g5318336

