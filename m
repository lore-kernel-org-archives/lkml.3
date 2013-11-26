Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3KZBYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:24:25 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52518 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3KZBYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:24:16 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] staging/lustre: fix build error on i386-randconfig
Date: Tue, 26 Nov 2013 09:23:57 +0800
Message-Id: <1385429037-9571-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild test robot reported:

All error/warnings:

   In file included from drivers/staging/lustre/lustre/llite/llite_internal.h:41:0,
                    from drivers/staging/lustre/lustre/llite/dcache.c:48:
>> drivers/staging/lustre/lustre/llite/../include/lustre_disk.h:499:28: error: field 'lsi_bdi' has incomplete type
     struct backing_dev_info   lsi_bdi;     /* each client mountpoint needs
                               ^
--
   In file included from drivers/staging/lustre/lustre/llite/llite_lib.c:51:0:
>> drivers/staging/lustre/lustre/llite/../include/lustre_disk.h:499:28: error: field 'lsi_bdi' has incomplete type
     struct backing_dev_info   lsi_bdi;     /* each client mountpoint needs
                               ^
   drivers/staging/lustre/lustre/llite/llite_lib.c: In function 'll_bdi_register':
>> drivers/staging/lustre/lustre/llite/llite_lib.c:953:5: error: dereferencing pointer to incomplete type
     bdi->name = "lustre";
        ^
>> drivers/staging/lustre/lustre/llite/llite_lib.c:954:2: error: implicit declaration of function 'bdi_register' [-Werror=implicit-function-declaration]
     return bdi_register(bdi, NULL, "lustre-%d",
     ^
   drivers/staging/lustre/lustre/llite/llite_lib.c: In function 'll_fill_super':
>> drivers/staging/lustre/lustre/llite/llite_lib.c:990:2: error: implicit declaration of function 'bdi_init' [-Werror=implicit-function-declaration]
     err = bdi_init(&lsi->lsi_bdi);
     ^
>> drivers/staging/lustre/lustre/llite/llite_lib.c:994:30: error: 'BDI_CAP_MAP_COPY' undeclared (first use in this function)
     lsi->lsi_bdi.capabilities = BDI_CAP_MAP_COPY;
                                 ^
   drivers/staging/lustre/lustre/llite/llite_lib.c:994:30: note: each undeclared identifier is reported only once for each function it appears in
   drivers/staging/lustre/lustre/llite/llite_lib.c: In function 'll_put_super':
>> drivers/staging/lustre/lustre/llite/llite_lib.c:1101:3: error: implicit declaration of function 'bdi_destroy' [-Werror=implicit-function-declaration]
      bdi_destroy(&lsi->lsi_bdi);
      ^
   cc1: some warnings being treated as errors

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../staging/lustre/lustre/include/lustre_disk.h    |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/include/lustre_disk.h b/drivers/staging/lustre/lustre/include/lustre_disk.h
index 9228b16..1de9a8b 100644
--- a/drivers/staging/lustre/lustre/include/lustre_disk.h
+++ b/drivers/staging/lustre/lustre/include/lustre_disk.h
@@ -50,6 +50,7 @@
 
 #include <linux/libcfs/libcfs.h>
 #include <linux/lnet/types.h>
+#include <linux/backing-dev.h>
 
 /****************** on-disk files *********************/
 
-- 
1.7.9.5

