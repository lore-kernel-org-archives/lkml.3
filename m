Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab3KNUcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:32:33 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:58618 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab3KNUc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:32:27 -0500
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, caizhiyong@huawei.com
Cc: akpm@linux-foundation.org, rdunlap@infradead.org, a.beregalov@gmail.com,
        Alexander Beregalov <alexander.beregalov@intel.com>
Subject: [PATCH] cmdline-parser: fix build
Date: Fri, 15 Nov 2013 00:32:16 +0400
Message-Id: <1384461136-5687-1-git-send-email-alexander.beregalov@intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following errors:
include/linux/cmdline-parser.h:17:12: error: 'BDEVNAME_SIZE' undeclared here
block/cmdline-parser.c:17:2: error: implicit declaration of function 'kzalloc'

Signed-off-by: Alexander Beregalov <alexander.beregalov@intel.com>
---
 include/linux/cmdline-parser.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/cmdline-parser.h b/include/linux/cmdline-parser.h
index 43b65a9..2e6dce6 100644
--- a/include/linux/cmdline-parser.h
+++ b/include/linux/cmdline-parser.h
@@ -8,6 +8,8 @@
 #define CMDLINEPARSEH
 
 #include <linux/blkdev.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
 
 /* partition flags */
 #define PF_RDONLY                   0x01 /* Device is read only */
-- 
1.8.4.2

