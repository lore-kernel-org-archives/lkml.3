Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaECUT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:19:29 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:44113 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbaECUT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:19:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoTAJ9OZVNXQD6Q/2dsb2JhbABZgwaDPagrCgUBmgYCAoERF3SCZhwjGIECJBOIRQHKAYVWiHyERgEDjxqKGQGKfod2gzY7
Date: Sat, 3 May 2014 22:19:18 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, dhowells <dhowells@redhat.com>
Subject: [PATCH 1/2] FS/FSCACHE: replace seq_printf by seq_puts
Message-Id: <20140503221918.c40480b8ba408279649de5d7@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace seq_printf where possible + coalesce formats from 2 existing seq_puts

Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/fscache/histogram.c   | 6 ++----
 fs/fscache/object-list.c | 8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/fscache/histogram.c b/fs/fscache/histogram.c
index bad4967..7d637e2 100644
--- a/fs/fscache/histogram.c
+++ b/fs/fscache/histogram.c
@@ -31,12 +31,10 @@ static int fscache_histogram_show(struct seq_file *m, void *v)
 
 	switch ((unsigned long) v) {
 	case 1:
-		seq_puts(m, "JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS "
-			 " RETRV DLY RETRIEVLS\n");
+		seq_puts(m, "JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS  RETRV DLY RETRIEVLS\n");
 		return 0;
 	case 2:
-		seq_puts(m, "===== ===== ========= ========= ========="
-			 " ========= =========\n");
+		seq_puts(m, "===== ===== ========= ========= ========= ========= =========\n");
 		return 0;
 	default:
 		index = (unsigned long) v - 3;
diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
index b5ebc2d..b8179ca 100644
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -285,20 +285,20 @@ static int fscache_objlist_show(struct seq_file *m, void *v)
 		fscache_unuse_cookie(obj);
 
 		if (keylen > 0 || auxlen > 0) {
-			seq_printf(m, " ");
+			seq_puts(m, " ");
 			for (p = buf; keylen > 0; keylen--)
 				seq_printf(m, "%02x", *p++);
 			if (auxlen > 0) {
 				if (config & FSCACHE_OBJLIST_CONFIG_KEY)
-					seq_printf(m, ", ");
+					seq_puts(m, ", ");
 				for (; auxlen > 0; auxlen--)
 					seq_printf(m, "%02x", *p++);
 			}
 		}
 
-		seq_printf(m, "\n");
+		seq_puts(m, "\n");
 	} else {
-		seq_printf(m, "<no_netfs>\n");
+		seq_puts(m, "<no_netfs>\n");
 	}
 	return 0;
 }
-- 
1.8.4.5
