Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaDOR6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:58:23 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35607 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDOR6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:58:21 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org
Subject: [PATCH] x86: suppress realmode.bin is up to date message
Date: Tue, 15 Apr 2014 13:58:13 -0400
Message-Id: <1397584693-15902-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

suppress the below unnecessary message.

make[3]: 'arch/x86/realmode/rm/realmode.bin' is up to date.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 arch/x86/realmode/rm/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 3497f14..7c0d7be 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -52,8 +52,9 @@ $(obj)/realmode.elf: $(obj)/realmode.lds $(REALMODE_OBJS) FORCE
 OBJCOPYFLAGS_realmode.bin := -O binary
 
 targets += realmode.bin
-$(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
+$(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs FORCE
 	$(call if_changed,objcopy)
+	@:
 
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
-- 
1.9.2

