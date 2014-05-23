Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaEWU0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:26:15 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:28641 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbaEWU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:26:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhULAHOuf1NR87wH/2dsb2JhbABbgwerCAQBAQEBAQEFAYM7lwKBCBd0glMTPxiBAiQTiEUB2EeFVYh9hEcBA48+ijMBixeIEIM6Ow
Date: Fri, 23 May 2014 22:26:11 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Petr Vandrovec <petr@vandrovec.name>
Subject: [PATCH 1/1] fs/ncpfs/getopt.c: replace simple_strtoul by kstrtoul
Message-Id: <20140523222611.862216f7570633a5bf0f0e89@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove obsolete simple_strtoul in ncp_getopt

This is untested.

Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ncpfs/getopt.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ncpfs/getopt.c b/fs/ncpfs/getopt.c
index 03ffde1..344889c 100644
--- a/fs/ncpfs/getopt.c
+++ b/fs/ncpfs/getopt.c
@@ -53,15 +53,14 @@ int ncp_getopt(const char *caller, char **options, const struct ncp_option *opts
 				return -EINVAL;
 			}
 			if (opts->has_arg & OPT_INT) {
-				char* v;
+				int rc = kstrtoul(val, 0, value);
 
-				*value = simple_strtoul(val, &v, 0);
-				if (!*v) {
-					return opts->val;
+				if (rc) {
+					pr_info("%s: invalid numeric value in %s=%s\n",
+						caller, token, val);
+					return rc;
 				}
-				pr_info("%s: invalid numeric value in %s=%s\n",
-					caller, token, val);
-				return -EDOM;
+				return opts->val;
 			}
 			if (opts->has_arg & OPT_STRING) {
 				return opts->val;
-- 
1.9.1
