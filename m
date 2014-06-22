Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaFVM3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 08:29:13 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56248 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaFVM3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 08:29:12 -0400
Message-ID: <53A6CC0E.5010000@gmail.com>
Date: Sun, 22 Jun 2014 20:29:02 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/include/asm/uaccess.h: Use standard clear_user()
 prototype
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard clear_user() just like another architectures, also match
__clear_user() under score.

The related warning (allmodconfig under score):

    CC [M]  drivers/md/dm-ioctl.o
  drivers/md/dm-ioctl.c: In function 'copy_params':
  drivers/md/dm-ioctl.c:1728:33: warning: passing argument 1 of 'clear_user' from incompatible pointer type
     if (secure_data && clear_user(user, param_kernel->data_size))
                                   ^
  In file included from include/linux/uaccess.h:5:0,
                   from include/linux/highmem.h:8,
                   from include/linux/bio.h:23,
                   from include/linux/device-mapper.h:11,
                   from drivers/md/dm.h:14,
                   from drivers/md/dm-ioctl.c:8:
  ./arch/score/include/asm/uaccess.h:364:29: note: expected 'char *' but argument is of type 'struct dm_ioctl *'
   static inline unsigned long clear_user(char *src, unsigned long size)
                               ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/include/asm/uaccess.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/score/include/asm/uaccess.h b/arch/score/include/asm/uaccess.h
index ab66ddd..259a539 100644
--- a/arch/score/include/asm/uaccess.h
+++ b/arch/score/include/asm/uaccess.h
@@ -361,7 +361,8 @@ copy_in_user(void *to, const void *from, unsigned long len)
  */
 extern unsigned long __clear_user(void __user *src, unsigned long size);
 
-static inline unsigned long clear_user(char *src, unsigned long size)
+static inline unsigned long __must_check clear_user(void __user *src,
+							unsigned long size)
 {
 	if (access_ok(VERIFY_WRITE, src, size))
 		return __clear_user(src, size);
-- 
1.9.2.459.g68773ac
