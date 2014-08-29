Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaH2DH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 23:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaH2DHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 23:07:25 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH] try to use automatic variable in kexec purgatory makefile
Date: Fri, 29 Aug 2014 11:05:39 +0800
Message-Id: <1409281539-2069-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes the Makefile of kexec purgatory be consistent with
others in linux src tree, and makes it look generic and simple.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/purgatory/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 7fde9ee..f44d1c5 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -17,8 +17,9 @@ $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 
 targets += kexec-purgatory.c
 
+CMD_BIN2C = $(objtree)/scripts/basic/bin2c
 quiet_cmd_bin2c = BIN2C   $@
-      cmd_bin2c = cat $(obj)/purgatory.ro | $(objtree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
+      cmd_bin2c = $(CMD_BIN2C) kexec_purgatory < $< > $@
 
 $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
 	$(call if_changed,bin2c)
-- 
1.8.5.3

