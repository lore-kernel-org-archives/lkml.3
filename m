Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3EZUf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 16:35:57 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:54223 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab3EZUfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 16:35:55 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 1/2] MIPS: cavium-octeon: cvmx-helper-board: print unknown board warning only once
Date: Sun, 26 May 2013 23:35:42 +0300
Message-Id: <1369600543-21558-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting a new board for the first time, the console is flooded with
"Unknown board" messages. This is not really helpful. Board type is not
going to change after the boot, so it's sufficient to print the warning
only once.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/cavium-octeon/executive/cvmx-helper-board.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
index 7c64977..e0451a0 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -31,6 +31,8 @@
  * network ports from the rest of the cvmx-helper files.
  */
 
+#include <linux/printk.h>
+
 #include <asm/octeon/octeon.h>
 #include <asm/octeon/cvmx-bootinfo.h>
 
@@ -184,8 +186,7 @@ int cvmx_helper_board_get_mii_address(int ipd_port)
 	}
 
 	/* Some unknown board. Somebody forgot to update this function... */
-	cvmx_dprintf
-	    ("cvmx_helper_board_get_mii_address: Unknown board type %d\n",
+	pr_warn_once("%s: Unknown board type %d\n", __func__,
 	     cvmx_sysinfo_get()->board_type);
 	return -1;
 }
-- 
1.7.10.4

