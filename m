Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbaFUMFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:05:37 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:46919 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934339AbaFUMFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:05:18 -0400
Date: Sat, 21 Jun 2014 13:05:14 +0100
From: Daniel Walter <dwalter@google.com>
To: Wan ZongShun <mcuos.com@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/9] [arch/arm/mach-w90x900] replace obsolete strict_strto
Message-ID: <20140621120514.GA6988@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace obsolete strict_strto with kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/arm/mach-w90x900/cpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index b1eabaa..213230ee 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -178,7 +178,8 @@ static int __init nuc900_set_cpufreq(char *str)
 	if (!*str)
 		return 0;
 
-	strict_strtoul(str, 0, &cpufreq);
+	if (kstrtoul(str, 0, &cpufreq))
+		return 0;
 
 	nuc900_clock_source(NULL, "ext");
 
-- 
2.0.0.526.g5318336

