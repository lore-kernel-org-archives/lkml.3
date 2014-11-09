Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaKIDr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 22:47:56 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58891 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaKIDry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 22:47:54 -0500
Message-ID: <545EE55E.4000601@gmail.com>
Date: Sun, 09 Nov 2014 11:54:06 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: oleg.drokin@intel.com, andreas.dilger@intel.com
CC: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de, ben@decadent.org.uk,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: staging: lustre: Kconfig: Let LUSTRE_LLITE_LLOOP
 depend on all !"*_64K*" page
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It does not support 64K page, so let it disabled for 64K page under all
architectures. The related error (with allmodconfig under tile):

    CC [M]  drivers/staging/lustre/lustre/llite/lloop.o
  In file included from drivers/staging/lustre/lustre/llite/../include/../../include/linux/libcfs/libcfs.h:160:0,
                   from drivers/staging/lustre/lustre/llite/../include/lustre_lib.h:52,
                   from drivers/staging/lustre/lustre/llite/lloop.c:106:
  drivers/staging/lustre/lustre/llite/lloop.c: In function 'loop_set_fd':
  drivers/staging/lustre/lustre/llite/../include/../../include/linux/libcfs/libcfs_private.h:411:54: error: duplicate case value
   #define CLASSERT(cond) do {switch (42) {case (cond): case 0: break; } } while (0)
                                                        ^
  drivers/staging/lustre/lustre/llite/lloop.c:525:2: note: in expansion of macro 'CLASSERT'
    CLASSERT(PAGE_CACHE_SIZE < (1 << (sizeof(unsigned short) * 8)));
    ^
  drivers/staging/lustre/lustre/llite/../include/../../include/linux/libcfs/libcfs_private.h:411:41: error: previously used here
   #define CLASSERT(cond) do {switch (42) {case (cond): case 0: break; } } while (0)
                                           ^
  drivers/staging/lustre/lustre/llite/lloop.c:525:2: note: in expansion of macro 'CLASSERT'
    CLASSERT(PAGE_CACHE_SIZE < (1 << (sizeof(unsigned short) * 8)));
    ^

Use "find ./ | grep Kconfig | xargs grep --color 64K" to find all 64K
page macros.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/lustre/lustre/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 4f65ba1..6725467 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -57,5 +57,5 @@ config LUSTRE_TRANSLATE_ERRNOS
 config LUSTRE_LLITE_LLOOP
 	tristate "Lustre virtual block device"
 	depends on LUSTRE_FS && BLOCK
-	depends on !PPC_64K_PAGES && !ARM64_64K_PAGES
+	depends on !PPC_64K_PAGES && !ARM64_64K_PAGES && !MICROBLAZE_64K_PAGES && !PAGE_SIZE_64KB && !IA64_PAGE_SIZE_64KB && !PARISC_PAGE_SIZE_64KB
 	default m
-- 
1.9.3
