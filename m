Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbbAPKu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:50:29 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:36633 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbbAPKu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:50:27 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86/boot/edd: return from query_edd so early as we can if EDD disabled
Date: Fri, 16 Jan 2015 16:50:17 +0600
Message-Id: <1421405417-23041-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0.44.ga94655d.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return from query_edd routine as early as we can if CONFIG_EDD_OFF was set 'Y'
and 'edd=on | skip[mbr]' parameter have not been transfered to the kernel.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/edd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index 223e425..79040d6 100644
--- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -139,19 +139,19 @@ void query_edd(void)
 			do_mbr = 0;
 		}
 		else if (!strcmp(eddarg, "off"))
-			do_edd = 0;
+			return;
 		else if (!strcmp(eddarg, "on"))
 			do_edd = 1;
 	}
 
+	if (!do_edd)
+		return;
+
 	be_quiet = cmdline_find_option_bool("quiet");
 
 	edp    = boot_params.eddbuf;
 	mbrptr = boot_params.edd_mbr_sig_buffer;
 
-	if (!do_edd)
-		return;
-
 	/* Bugs in OnBoard or AddOnCards Bios may hang the EDD probe,
 	 * so give a hint if this happens.
 	 */
-- 
2.3.0.rc0.44.ga94655d.dirty

