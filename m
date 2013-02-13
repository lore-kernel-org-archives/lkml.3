Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926Ab3BMMEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:04:51 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55519 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759315Ab3BMMEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:04:48 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 4/5] genksyms: fix metag symbol prefix on crc symbols
Date: Wed, 13 Feb 2013 12:03:48 +0000
Message-ID: <1360757029-28868-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
References: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_13_12_04_48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meta uses symbol prefixes, so add "metag" to the list of architectures
to set the mod_prefix to "_" for. This fixes __crc_* symbols to add the
extra underscore to match _CRC_SYMBOL macro in <linux/export.h> and so
that modpost finds them.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 scripts/genksyms/genksyms.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index 8a10649..d25e4a1 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -826,7 +826,8 @@ int main(int argc, char **argv)
 			genksyms_usage();
 			return 1;
 		}
-	if ((strcmp(arch, "h8300") == 0) || (strcmp(arch, "blackfin") == 0))
+	if ((strcmp(arch, "h8300") == 0) || (strcmp(arch, "blackfin") == 0) ||
+	    (strcmp(arch, "metag") == 0))
 		mod_prefix = "_";
 	{
 		extern int yydebug;
-- 
1.7.7.6


