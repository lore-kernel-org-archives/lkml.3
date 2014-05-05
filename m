Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaEERjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:39:13 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:9814 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbaEERjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:39:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAArMZ1NbsEtU/2dsb2JhbABQCYMGq1EHAQIFAZoMgRcXdIJmHCMYgQIkE4hFAcwMhVaIIVuERgEDjxqKGQGKfod2gzY7
Date: Mon, 5 May 2014 19:39:07 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/exec_domain.c: code clean-up
Message-Id: <20140505193907.6d5f5e1b9438caac5a04403e@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing checkpatch warnings about EXPORT_SYMBOL and return()

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/exec_domain.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/exec_domain.c b/kernel/exec_domain.c
index 0dbeae3..83d4382 100644
--- a/kernel/exec_domain.c
+++ b/kernel/exec_domain.c
@@ -37,7 +37,7 @@ static unsigned long ident_map[32] = {
 struct exec_domain default_exec_domain = {
 	.name		= "Linux",		/* name */
 	.handler	= default_handler,	/* lcall7 causes a seg fault. */
-	.pers_low	= 0, 			/* PER_LINUX personality. */
+	.pers_low	= 0,			/* PER_LINUX personality. */
 	.pers_high	= 0,			/* PER_LINUX personality. */
 	.signal_map	= ident_map,		/* Identity map signals. */
 	.signal_invmap	= ident_map,		/*  - both ways. */
@@ -83,7 +83,7 @@ lookup_exec_domain(unsigned int personality)
 	ep = &default_exec_domain;
 out:
 	read_unlock(&exec_domains_lock);
-	return (ep);
+	return ep;
 }
 
 int
@@ -110,8 +110,9 @@ register_exec_domain(struct exec_domain *ep)
 
 out:
 	write_unlock(&exec_domains_lock);
-	return (err);
+	return err;
 }
+EXPORT_SYMBOL(register_exec_domain);
 
 int
 unregister_exec_domain(struct exec_domain *ep)
@@ -133,6 +134,7 @@ unregister:
 	write_unlock(&exec_domains_lock);
 	return 0;
 }
+EXPORT_SYMBOL(unregister_exec_domain);
 
 int __set_personality(unsigned int personality)
 {
@@ -144,6 +146,7 @@ int __set_personality(unsigned int personality)
 
 	return 0;
 }
+EXPORT_SYMBOL(__set_personality);
 
 #ifdef CONFIG_PROC_FS
 static int execdomains_proc_show(struct seq_file *m, void *v)
@@ -188,8 +191,3 @@ SYSCALL_DEFINE1(personality, unsigned int, personality)
 
 	return old;
 }
-
-
-EXPORT_SYMBOL(register_exec_domain);
-EXPORT_SYMBOL(unregister_exec_domain);
-EXPORT_SYMBOL(__set_personality);
-- 
1.9.1
