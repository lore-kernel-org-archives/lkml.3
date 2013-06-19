Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab3FSHxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:53:10 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:48467 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934022Ab3FSHxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:53:08 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: [PATCH -resend] X86: boot, close opened descriptor
Date: Wed, 19 Jun 2013 09:53:03 +0200
Message-Id: <1371628383-11216-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In build, we open a file, read that but do not close it. Fix that by
sticking fclose at the right place.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
---
 arch/x86/boot/tools/build.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 94c5446..c941d6a 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -243,6 +243,7 @@ static void parse_zoffset(char *fname)
 	c = fread(buf, 1, sizeof(buf) - 1, file);
 	if (ferror(file))
 		die("read-error on `zoffset.h'");
+	fclose(file);
 	buf[c] = 0;
 
 	p = (char *)buf;
-- 
1.8.3.1

