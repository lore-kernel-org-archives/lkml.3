Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaFAXxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 19:53:11 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:32821 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaFAXxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 19:53:10 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: skein: fix sparse warning for static declarations
Date: Sun,  1 Jun 2014 19:52:49 -0400
Message-Id: <1401666769-16582-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

skein_block.c:43:6: warning: symbol 'skein_256_process_block' was not declared. Should it be static?
skein_block.c:252:6: warning: symbol 'skein_512_process_block' was not declared. Should it be static?
skein_block.c:483:6: warning: symbol 'skein_1024_process_block' was not declared. Should it be static?

by including the header skein_block.h, which contains the declarations in
question.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/skein/skein_block.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index f49eb2e..04ce1d0 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -16,6 +16,7 @@
 
 #include <linux/string.h>
 #include "skein.h"
+#include "skein_block.h"
 
 #ifndef SKEIN_USE_ASM
 #define SKEIN_USE_ASM   (0) /* default is all C code (no ASM) */
-- 
1.7.9.5

