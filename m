Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3FERJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:09:50 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56375 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3FERJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:09:49 -0400
From: Rasmus Villemoes <mail@rasmusvillemoes.dk>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: use IS_ERR_VALUE() in memory_lseek()
Date: Wed,  5 Jun 2013 17:09:39 +0000
Message-Id: <1370452179-28230-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use IS_ERR_VALUE() instead of comparing the new offset to a hard-coded
value of -MAX_ERRNO (which is also off-by-one due to the use of ~
instead of -).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/char/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1ccbe94..2ca6d78 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -745,7 +745,7 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 		offset += file->f_pos;
 	case SEEK_SET:
 		/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
-		if ((unsigned long long)offset >= ~0xFFFULL) {
+		if (IS_ERR_VALUE((unsigned long long)offset)) {
 			ret = -EOVERFLOW;
 			break;
 		}
-- 
1.7.9.5

