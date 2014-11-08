Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaKHLkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 06:40:14 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:53095 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbaKHLkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 06:40:11 -0500
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Alban Bedel <albeu@free.fr>
Subject: [PATCH v2 2/2] MIPS: FW: Use kstrtoul() to parse unsigned long from the fw environment
Date: Sat,  8 Nov 2014 12:39:39 +0100
Message-Id: <1415446779-11984-2-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1415446779-11984-1-git-send-email-albeu@free.fr>
References: <1415446779-11984-1-git-send-email-albeu@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some value corruptions with values that can't be represented in a
signed long.

Signed-off-by: Alban Bedel <albeu@free.fr>
---
v2: * No changes since v1
---
 arch/mips/fw/lib/cmdline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/fw/lib/cmdline.c b/arch/mips/fw/lib/cmdline.c
index a0c361e..6ecda64 100644
--- a/arch/mips/fw/lib/cmdline.c
+++ b/arch/mips/fw/lib/cmdline.c
@@ -88,13 +88,13 @@ unsigned long fw_getenvl(char *envname)
 {
 	unsigned long envl = 0UL;
 	char *str;
-	long val;
 	int tmp;
 
 	str = fw_getenv(envname);
 	if (str) {
-		tmp = kstrtol(str, 0, &val);
-		envl = (unsigned long)val;
+		tmp = kstrtoul(str, 0, &envl);
+		if (tmp)
+			envl = 0;
 	}
 
 	return envl;
-- 
2.0.0

