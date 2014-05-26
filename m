Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaEZWKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:10:49 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:37321 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaEZWKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:10:48 -0400
Date: Mon, 26 May 2014 23:10:43 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, richard@nod.at
Subject: [PATCH 07/12] [arch/mips] Remove obsolete strict_strto calls
Message-ID: <20140526221043.GI25779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH 07/12] [arch/mips] replace obsolete strict_strto calls

Replace obsolete strict_strto call with more appropriate calls
to kstrto*

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/mips/pci/ops-tx4927.c     | 9 ++++++---
 arch/mips/txx9/generic/setup.c | 4 ++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/mips/pci/ops-tx4927.c b/arch/mips/pci/ops-tx4927.c
index 3d5df51..0e046d8 100644
--- a/arch/mips/pci/ops-tx4927.c
+++ b/arch/mips/pci/ops-tx4927.c
@@ -202,17 +202,20 @@ char *tx4927_pcibios_setup(char *str)
 	unsigned long val;
 
 	if (!strncmp(str, "trdyto=", 7)) {
-		if (strict_strtoul(str + 7, 0, &val) == 0)
+		u8 val = 0;
+		if (kstrtou8(str + 7, 0, &val) == 0)
 			tx4927_pci_opts.trdyto = val;
 		return NULL;
 	}
 	if (!strncmp(str, "retryto=", 8)) {
-		if (strict_strtoul(str + 8, 0, &val) == 0)
+		u8 val = 0;
+		if (kstrtou8(str + 8, 0, &val) == 0)
 			tx4927_pci_opts.retryto = val;
 		return NULL;
 	}
 	if (!strncmp(str, "gbwc=", 5)) {
-		if (strict_strtoul(str + 5, 0, &val) == 0)
+		u16 val;
+		if (kstrtou16(str + 5, 0, &val) == 0)
 			tx4927_pci_opts.gbwc = val;
 		return NULL;
 	}
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 2b0b83c..dd2cf25 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -309,8 +309,8 @@ static void __init preprocess_cmdline(void)
 			txx9_board_vec = find_board_byname(str + 6);
 			continue;
 		} else if (strncmp(str, "masterclk=", 10) == 0) {
-			unsigned long val;
-			if (strict_strtoul(str + 10, 10, &val) == 0)
+			unsigned int val;
+			if (kstrtouint(str + 10, 10, &val) == 0)
 				txx9_master_clock = val;
 			continue;
 		} else if (strcmp(str, "icdisable") == 0) {
-- 
1.9.3

