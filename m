Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaFCPUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:20:22 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36462 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaFCPUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:20:17 -0400
Date: Tue, 3 Jun 2014 16:20:13 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: richard@nod.at, akpm@linux-foundation.org, mcuos.com@gmail.com
Subject: [PATCH v2 04/11] [arch/arm/mach-w90x900] replace obsolete
 strict_strto
Message-ID: <20140603152013.GF28580@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 04/11] [arch/arm/mach-w90x900] replace obsolete strict_strto

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
1.9.3

