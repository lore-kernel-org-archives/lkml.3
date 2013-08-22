Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3HVUZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:25:45 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:46296 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3HVUZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:25:43 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2 2/5] x86: don't use echo -e needlessly
Date: Fri, 23 Aug 2013 00:25:22 +0400
Message-Id: <1377203125-22934-3-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
References: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-e is not needed to output strings without escape sequences.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/x86/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 07639c6..0954686 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -95,7 +95,7 @@ endif
 
 ifdef CONFIG_X86_X32
 	x32_ld_ok := $(call try-run,\
-			/bin/echo -e '1: .quad 1b' | \
+			echo '1: .quad 1b' | \
 			$(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" - && \
 			$(OBJCOPY) -O elf32-x86-64 "$$TMP" "$$TMPO" && \
 			$(LD) -m elf32_x86_64 "$$TMPO" -o "$$TMP",y,n)
-- 
1.7.7.6

