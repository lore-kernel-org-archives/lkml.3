Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3GONL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:11:26 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63221 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab3GONLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:11:17 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 09/17] staging/lustre/llite: add missing include file for prefetchw
Date: Mon, 15 Jul 2013 21:08:07 +0800
Message-Id: <1373893695-4094-10-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
References: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got below errors on s390 build:
  CC [M]  drivers/staging/lustre/lustre/llite/dir.o
drivers/staging/lustre/lustre/llite/dir.c: In function 'll_dir_filler':
drivers/staging/lustre/lustre/llite/dir.c:225:3: error: implicit declaration of function 'prefetchw' [-Werror=implicit-function-declaration]

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dir.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 23c61fe..13a6426 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -45,6 +45,7 @@
 #include <asm/uaccess.h>
 #include <linux/buffer_head.h>   // for wait_on_buffer
 #include <linux/pagevec.h>
+#include <linux/prefetch.h>
 
 #define DEBUG_SUBSYSTEM S_LLITE
 
-- 
1.7.9.5

