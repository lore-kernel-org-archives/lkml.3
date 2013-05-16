Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3EPLd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:33:56 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9892 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3EPLdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:33:55 -0400
X-Spam-Score: -100.7
Message-ID: <5194C3EF.8030508@asianux.com>
Date: Thu, 16 May 2013 19:33:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel: debug: memcpy overlaped, use memmove instead of
 memcpy.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For memcpy(), src and dest are overlaped: for default implementaion or
some architectures, it is OK,  but we can not be sure that it is OK for
all platforms, and in this condition, the performance are not quite
important.

So let memmove instead of memcpy.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/debug/kdb/kdb_support.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index d35cc2d..990b3cc 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -129,13 +129,13 @@ int kdbnearsym(unsigned long addr, kdb_symtab_t *symtab)
 		}
 		if (i >= ARRAY_SIZE(kdb_name_table)) {
 			debug_kfree(kdb_name_table[0]);
-			memcpy(kdb_name_table, kdb_name_table+1,
+			memmove(kdb_name_table, kdb_name_table+1,
 			       sizeof(kdb_name_table[0]) *
 			       (ARRAY_SIZE(kdb_name_table)-1));
 		} else {
 			debug_kfree(knt1);
 			knt1 = kdb_name_table[i];
-			memcpy(kdb_name_table+i, kdb_name_table+i+1,
+			memmove(kdb_name_table+i, kdb_name_table+i+1,
 			       sizeof(kdb_name_table[0]) *
 			       (ARRAY_SIZE(kdb_name_table)-i-1));
 		}
-- 
1.7.7.6
