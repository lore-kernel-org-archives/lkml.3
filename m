Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3KOOhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:37:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38243 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750960Ab3KOOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:36:52 -0500
Date: Fri, 15 Nov 2013 09:36:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Yang Bai <hamo.by@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scripts: Have make TAGS not include structure members
Message-ID: <20131115093645.6dc03918@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is really annoying when I use emacs TAGS to search for something
like "dev_name" and have to go through 12 iterations before I find the
function "dev_name". I really do not care about structures that include
"dev_name" as one of its fields, and I'm sure pretty much all other
developers do not care either.

There's a "remove_structs" variable used by the scripts/tags.sh, which
I'm guessing is suppose to remove these structures from the TAGS file,
but it must do a poor job at it, as I'm always hitting structures when
I want the actual declaration.

Luckily, the etags and ctags program comes with an option
"--no-members", which does exactly what I want, and I'm sure all other
kernel developers want too.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 74f02e4..b985371 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -218,7 +218,7 @@ exuberant()
 
 emacs()
 {
-	all_target_sources | xargs $1 -a                        \
+	all_target_sources | xargs $1 -a --no-members           \
 	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
@@ -248,13 +248,13 @@ emacs()
 	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
 	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'
 
-	all_kconfigs | xargs $1 -a                              \
+	all_kconfigs | xargs $1 -a --no-members                 \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
 
-	all_kconfigs | xargs $1 -a                              \
+	all_kconfigs | xargs $1 -a --no-members                 \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/CONFIG_\3/'
 
-	all_defconfigs | xargs -r $1 -a                         \
+	all_defconfigs | xargs -r $1 -a --no-members            \
 	--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'
 }
 
