Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaA2RMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:12:09 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:19671 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbaA2RMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:12:05 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUgAHk16VJbtAe+/2dsb2JhbABZKIJkOIMCpH+VUwICgQYXdIJTExwjGIECN4gJAcoYjhtkHYQiBIlHjmABik+HUIM6L4Es
Date: Wed, 29 Jan 2014 17:13:16 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, akpm@linux-foundation.org, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
Subject: [PATCH 1/1] fs: udf: parse_options: blocksize check
Message-Id: <20140129171316.ad5c50a7091e67b7ff1d329b@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both affs and isofs check for blocksize integrity during
parse_options.Do the same thing for udf.

Valid values : 512, 1024, 2048 or 4096 bytes.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/udf/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 3306b9f..ac76538 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -505,6 +505,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 	while ((p = strsep(&options, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		int token;
+		unsigned n;
 		if (!*p)
 			continue;
 
@@ -516,7 +517,10 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 		case Opt_bs:
 			if (match_int(&args[0], &option))
 				return 0;
-			uopt->blocksize = option;
+			n = option;
+			if (n != 512 && n != 1024 && n != 2048 && n != 4096)
+				return 0;
+			uopt->blocksize = n;
 			uopt->flags |= (1 << UDF_FLAG_BLOCKSIZE_SET);
 			break;
 		case Opt_unhide:
-- 
1.8.1.4

