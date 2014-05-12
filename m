Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaELSSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:18:42 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:1336 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbaELSSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:18:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KACoQcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxhqGCQTiC0DFQHJOg2GDIVWhmWCF4RHAQOPJYgxgXEBiwSCG4Vogzg7
Date: Mon, 12 May 2014 20:18:33 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] net/x25/x25_proc.c: code clean-up
Message-Id: <20140512201833.b8542c4d190b09add29bf148@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing some checkpatch warnings

Cc: Andrew Hendry <andrew.hendry@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/x25/x25_proc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/x25/x25_proc.c b/net/x25/x25_proc.c
index 0917f04..fa79117 100644
--- a/net/x25/x25_proc.c
+++ b/net/x25/x25_proc.c
@@ -88,23 +88,23 @@ static int x25_seq_socket_show(struct seq_file *seq, void *v)
 	const char *devname;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_printf(seq, "dest_addr  src_addr   dev   lci st vs vr "
-				"va   t  t2 t21 t22 t23 Snd-Q Rcv-Q inode\n");
+		seq_puts(seq, "dest_addr  src_addr   dev   lci st vs vr va   t  t2 t21 t22 t23 Snd-Q Rcv-Q inode\n");
 		goto out;
 	}
 
 	s = sk_entry(v);
 	x25 = x25_sk(s);
+	dev = x25->neighbour->dev;
 
-	if (!x25->neighbour || (dev = x25->neighbour->dev) == NULL)
+	if (!x25->neighbour || !dev)
 		devname = "???";
 	else
 		devname = x25->neighbour->dev->name;
 
-	seq_printf(seq, "%-10s %-10s %-5s %3.3X  %d  %d  %d  %d %3lu %3lu "
-			"%3lu %3lu %3lu %5d %5d %ld\n",
+	seq_printf(seq, "%-10s %-10s %-5s %3.3X  %d  %d  %d  %d %3lu %3lu %3lu %3lu %3lu %5d %5d %ld\n",
 		   !x25->dest_addr.x25_addr[0] ? "*" : x25->dest_addr.x25_addr,
-		   !x25->source_addr.x25_addr[0] ? "*" : x25->source_addr.x25_addr,
+		   !x25->source_addr.x25_addr[0] ? "*" :
+		   x25->source_addr.x25_addr,
 		   devname, x25->lci & 0x0FFF, x25->state, x25->vs, x25->vr,
 		   x25->va, x25_display_timer(s) / HZ, x25->t2  / HZ,
 		   x25->t21 / HZ, x25->t22 / HZ, x25->t23 / HZ,
@@ -138,7 +138,7 @@ static int x25_seq_forward_show(struct seq_file *seq, void *v)
 	struct x25_forward *f = list_entry(v, struct x25_forward, node);
 
 	if (v == &x25_forward_list) {
-		seq_printf(seq, "lci dev1       dev2\n");
+		seq_puts(seq, "lci dev1       dev2\n");
 		goto out;
 	}
 
-- 
1.9.1

