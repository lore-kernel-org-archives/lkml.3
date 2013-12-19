Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3LSJw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:52:27 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50778 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LSJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:52:25 -0500
Date: Thu, 19 Dec 2013 15:22:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH 13/13] drivers: block: Remove unused function in
 genl_magic_func.h
Message-ID: <6ad65a8d9a9f0467f2ad080e0a4db7ea49142371.1387445397.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused function CONCAT_(GENL_MAGIC_FAMILY, _genl_cmd_to_str) in
include/linux/genl_magic_func.h.

This eliminates the following warning in
include/linux/genl_magic_func.h:
include/linux/genl_magic_func.h:221:1: warning: no previous prototype for ‘drbd_genl_cmd_to_str’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 include/linux/genl_magic_func.h |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index c0894dd..0456ad8 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -214,22 +214,6 @@ static int s_name ## _from_attrs_for_change(struct s_name *s,		\
 #undef GENL_struct
 #define GENL_struct(tag_name, tag_number, s_name, s_fields)
 
-/*
- * Magic: define op number to op name mapping				{{{1
- *									{{{2
- */
-const char *CONCAT_(GENL_MAGIC_FAMILY, _genl_cmd_to_str)(__u8 cmd)
-{
-	switch (cmd) {
-#undef GENL_op
-#define GENL_op(op_name, op_num, handler, tla_list)		\
-	case op_num: return #op_name;
-#include GENL_MAGIC_INCLUDE_FILE
-	default:
-		     return "unknown";
-	}
-}
-
 #ifdef __KERNEL__
 #include <linux/stringify.h>
 /*
-- 
1.7.9.5

