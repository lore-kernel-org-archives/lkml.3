Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaJNErq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 00:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaJNErp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 00:47:45 -0400
From: WANG Chao <chaowang@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Baoquan He <bhe@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [PATCH] arch/x86/purgatory/Makefile: supress kexec-purgatory.c is up to date message
Date: Tue, 14 Oct 2014 12:46:58 +0800
Message-Id: <1413262019-3759-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supress this unnecessary message during kernel re-build
(CONFIG_KEXEC_FILE=y):

make[1]: `arch/x86/purgatory/kexec-purgatory.c' is up to date.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 arch/x86/purgatory/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index f52e033..2c835e3 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -24,6 +24,7 @@ quiet_cmd_bin2c = BIN2C   $@
 
 $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
 	$(call if_changed,bin2c)
+	@:
 
 
 obj-$(CONFIG_KEXEC_FILE)	+= kexec-purgatory.o
-- 
1.9.3

