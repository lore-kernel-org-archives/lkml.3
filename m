Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161096AbaDPNZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:25:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbaDPNZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:25:14 -0400
Date: Wed, 16 Apr 2014 06:24:46 -0700
From: tip-bot for Peter Foley <tipbot@zytor.com>
Message-ID: <tip-a9358bc3531901a15e2f7cd48550c9555fc0288f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pefoley2@pefoley.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, pefoley2@pefoley.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1397584693-15902-1-git-send-email-pefoley2@pefoley.com>
References: <1397584693-15902-1-git-send-email-pefoley2@pefoley.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86/build:
  Supress realmode.bin is up to date message
Git-Commit-ID: a9358bc3531901a15e2f7cd48550c9555fc0288f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9358bc3531901a15e2f7cd48550c9555fc0288f
Gitweb:     http://git.kernel.org/tip/a9358bc3531901a15e2f7cd48550c9555fc0288f
Author:     Peter Foley <pefoley2@pefoley.com>
AuthorDate: Tue, 15 Apr 2014 13:58:13 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Apr 2014 15:17:24 +0200

x86/build: Supress realmode.bin is up to date message

Supress this unnecessary message during kernel re-build:

   make[3]: 'arch/x86/realmode/rm/realmode.bin' is up to date.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Link: http://lkml.kernel.org/r/1397584693-15902-1-git-send-email-pefoley2@pefoley.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
