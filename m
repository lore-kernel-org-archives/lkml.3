Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaECUJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:09:37 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:14413 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbaECUJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:09:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkTAMRLZVNXQD6Q/2dsb2JhbABZgwaCQXyoKwoFAZoGAgKBEBd0glMTHCMYgQIkE4hFAcl+hVaIfIRGAQOPGooZAYp+h3aDNjs
Date: Sat, 3 May 2014 22:09:26 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sage <sage@inktank.com>
Subject: [PATCH 1/1] fs/ceph/debugfs.c: replace seq_printf by seq_puts
Message-Id: <20140503220926.a5372e2e7b8c83e477475a89@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace seq_printf where possible

Cc: Sage Weil <sage@inktank.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ceph/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 16b54aa..5a743ac 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -71,9 +71,9 @@ static int mdsc_show(struct seq_file *s, void *p)
 		seq_printf(s, "%s", ceph_mds_op_name(req->r_op));
 
 		if (req->r_got_unsafe)
-			seq_printf(s, "\t(unsafe)");
+			seq_puts(s, "\t(unsafe)");
 		else
-			seq_printf(s, "\t");
+			seq_puts(s, "\t");
 
 		if (req->r_inode) {
 			seq_printf(s, " #%llx", ceph_ino(req->r_inode));
@@ -119,7 +119,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 				seq_printf(s, " %s", req->r_path2);
 		}
 
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
 	mutex_unlock(&mdsc->mutex);
 
-- 
1.8.4.5

