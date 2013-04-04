Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764911Ab3DDUcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:32:20 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51048 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1764852Ab3DDUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:32:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: [PATCH 4/5] X86: boot, close opened descriptor
Date: Thu,  4 Apr 2013 22:32:11 +0200
Message-Id: <1365107532-32721-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
References: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
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
1.8.2


