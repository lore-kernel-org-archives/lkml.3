Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbbACJan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 04:30:43 -0500
Received: from out11.biz.mail.alibaba.com ([205.204.114.131]:39852 "EHLO
	out11.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbbACJaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 04:30:39 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.06701407|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r46d02036;MF=gang.chen@sunrus.com.cn;PH=DS;RN=4;RT=4;SR=0;
Message-ID: <54A7B663.3010507@sunrus.com.cn>
Date: Sat, 03 Jan 2015 17:29:07 +0800
From: Chen Gang <gang.chen@sunrus.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
CC: linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] s390: boot: compressed: misc: Express the return value of
 _sclp_print_early()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_sclp_print_early() has return value: at present, return 0 for OK, 1 for
failure. It returns '%r2', so use 'long' as return value (upper caller
can check '%r2' directly). The related warning:

    CC      arch/s390/boot/compressed/misc.o
  arch/s390/boot/compressed/misc.c:66:8: warning: type defaults to 'int' in declaration of '_sclp_print_early' [-Wimplicit-int]
   extern _sclp_print_early(const char *);
          ^

At present, _sclp_print_early() is only used by puts(), so can still
remain its declaration in 'misc.c' file.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/s390/boot/compressed/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index 57cbaff..09003b2 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -63,7 +63,7 @@ static unsigned long free_mem_end_ptr;
 #include "../../../../lib/decompress_unxz.c"
 #endif
 
-extern _sclp_print_early(const char *);
+extern long _sclp_print_early(const char *);
 
 static int puts(const char *s)
 {
-- 
1.7.9.5
