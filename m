Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaECU2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:28:53 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:49560 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbaECU2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:28:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsTAOhQZVNXQD6Q/2dsb2JhbABZgwaDPagsCgUBmgYCAoERF3SCUxMcIxiBAiQTiEUBygCFVoh8hEYBA48aihkBin6HdoM2Ow
Date: Sat, 3 May 2014 22:28:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>, Viro <viro@zeniv.linux.org.uk>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/locks.c: replace seq_printf by seq_puts
Message-Id: <20140503222843.771ebf5e7ce18243fd2a5c30@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace seq_printf where possible

Cc: Jeff Layton <jlayton@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/locks.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index e663aea..78ac209 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2411,31 +2411,31 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 	seq_printf(f, "%lld:%s ", id, pfx);
 	if (IS_POSIX(fl)) {
 		if (fl->fl_flags & FL_ACCESS)
-			seq_printf(f, "ACCESS");
+			seq_puts(f, "ACCESS");
 		else if (IS_OFDLCK(fl))
-			seq_printf(f, "OFDLCK");
+			seq_puts(f, "OFDLCK");
 		else
-			seq_printf(f, "POSIX ");
+			seq_puts(f, "POSIX ");
 
 		seq_printf(f, " %s ",
 			     (inode == NULL) ? "*NOINODE*" :
 			     mandatory_lock(inode) ? "MANDATORY" : "ADVISORY ");
 	} else if (IS_FLOCK(fl)) {
 		if (fl->fl_type & LOCK_MAND) {
-			seq_printf(f, "FLOCK  MSNFS     ");
+			seq_puts(f, "FLOCK  MSNFS     ");
 		} else {
-			seq_printf(f, "FLOCK  ADVISORY  ");
+			seq_puts(f, "FLOCK  ADVISORY  ");
 		}
 	} else if (IS_LEASE(fl)) {
-		seq_printf(f, "LEASE  ");
+		seq_puts(f, "LEASE  ");
 		if (lease_breaking(fl))
-			seq_printf(f, "BREAKING  ");
+			seq_puts(f, "BREAKING  ");
 		else if (fl->fl_file)
-			seq_printf(f, "ACTIVE    ");
+			seq_puts(f, "ACTIVE    ");
 		else
-			seq_printf(f, "BREAKER   ");
+			seq_puts(f, "BREAKER   ");
 	} else {
-		seq_printf(f, "UNKNOWN UNKNOWN  ");
+		seq_puts(f, "UNKNOWN UNKNOWN  ");
 	}
 	if (fl->fl_type & LOCK_MAND) {
 		seq_printf(f, "%s ",
@@ -2467,7 +2467,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 		else
 			seq_printf(f, "%Ld %Ld\n", fl->fl_start, fl->fl_end);
 	} else {
-		seq_printf(f, "0 EOF\n");
+		seq_puts(f, "0 EOF\n");
 	}
 }
 
-- 
1.8.4.5

