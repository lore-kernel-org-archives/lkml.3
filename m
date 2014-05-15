Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaEORCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:02:52 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:59934 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbaEORCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:02:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMRAGLydFNXQwiB/2dsb2JhbABZgwaDPqhZBAEBAQEBAQUBmhkCAoERF3SCUxMcIxiBAiQTiEUB0SuFVIh6hEcBA48qiiYBiw2IB4M4Ow
Date: Thu, 15 May 2014 19:02:48 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/hfsplus/options.c: replace seq_printf by seq_puts
Message-Id: <20140515190248.2692f498ec1ecd5fe26c30ff@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace seq_printf where possible

Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hfsplus/options.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 68537e8..c90b72e 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -173,9 +173,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 			if (p)
 				sbi->nls = load_nls(p);
 			if (!sbi->nls) {
-				pr_err("unable to load "
-						"nls mapping \"%s\"\n",
-					p);
+				pr_err("unable to load nls mapping \"%s\"\n",
+				       p);
 				kfree(p);
 				return 0;
 			}
@@ -232,8 +231,8 @@ int hfsplus_show_options(struct seq_file *seq, struct dentry *root)
 	if (sbi->nls)
 		seq_printf(seq, ",nls=%s", sbi->nls->charset);
 	if (test_bit(HFSPLUS_SB_NODECOMPOSE, &sbi->flags))
-		seq_printf(seq, ",nodecompose");
+		seq_puts(seq, ",nodecompose");
 	if (test_bit(HFSPLUS_SB_NOBARRIER, &sbi->flags))
-		seq_printf(seq, ",nobarrier");
+		seq_puts(seq, ",nobarrier");
 	return 0;
 }
-- 
1.8.4.5
