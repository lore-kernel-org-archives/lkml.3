Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaFDPnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:43:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaFDPnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:43:16 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <jbeulich@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH] ftrace/x86: Use kernel identity mapping only when CONFIG_DEBUG_RODATA enabled
Date: Wed,  4 Jun 2014 17:42:46 +0200
Message-Id: <1401896566-8028-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a tiny optimization. The remapping is not needed when the
kernel text mapping is read write all the time.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cbc4a91b131e..a7a517bb793e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -79,6 +79,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 
 static unsigned long text_ip_addr(unsigned long ip)
 {
+#ifdef CONFIG_DEBUG_RODATA
 	/*
 	 * On x86_64, kernel text mappings are mapped read-only with
 	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
@@ -89,7 +90,7 @@ static unsigned long text_ip_addr(unsigned long ip)
 	 */
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
 		ip = (unsigned long)__va(__pa_symbol(ip));
-
+#endif
 	return ip;
 }
 
-- 
1.8.4

