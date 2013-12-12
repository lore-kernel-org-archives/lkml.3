Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3LLQyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:54:46 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24754 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3LLQyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:41 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3/9] hfs: Known exploit detection for CVE-2011-4330
Date: Thu, 12 Dec 2013 17:52:26 +0100
Message-Id: <1386867152-24072-3-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

See bc5b8a9003132ae44559edd63a1623b7b99dfb68.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/hfs/trans.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/hfs/trans.c b/fs/hfs/trans.c
index b1ce4c7..2fe83f0 100644
--- a/fs/hfs/trans.c
+++ b/fs/hfs/trans.c
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/nls.h>
+#include <linux/exploit.h>
 
 #include "hfs_fs.h"
 
@@ -40,8 +41,10 @@ int hfs_mac2asc(struct super_block *sb, char *out, const struct hfs_name *in)
 
 	src = in->name;
 	srclen = in->len;
-	if (srclen > HFS_NAMELEN)
+	if (srclen > HFS_NAMELEN) {
+		exploit("CVE-2011-4330");
 		srclen = HFS_NAMELEN;
+	}
 	dst = out;
 	dstlen = HFS_MAX_NAMELEN;
 	if (nls_io) {
-- 
1.7.10.4

