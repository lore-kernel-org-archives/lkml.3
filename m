Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaLBW10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:27:26 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54689 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbaLBW1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:27:25 -0500
Message-ID: <547E3D38.6070406@gmail.com>
Date: Wed, 03 Dec 2014 06:29:12 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, vthakkar1994@gmail.com,
        mahati.chamarthy@gmail.com, mdcasey@chabloom.com,
        standby24x7@gmail.com, paulmcquad@gmail.com
CC: devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: staging: rtl8192e: Include "asm/unaligned.h" instead
 of "access_ok.h" in "rtl819x_BAProc.c"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"asm/unaligned.h" is more generic than "access_ok.h", and it may include
"access_ok.h", so need use it instead of "access_ok.h".

During building, "rtllib.h" has already include "asm/unaligned.h", so
will cause building issue. The related error (with allmodconfig under
parisc):

    CC [M]  drivers/staging/rtl8192e/rtl819x_BAProc.o
  In file included from ./arch/parisc/include/asm/unaligned.h:4:0,
                   from include/linux/ieee80211.h:22,
                   from include/net/lib80211.h:31,
                   from drivers/staging/rtl8192e/rtllib.h:45,
                   from drivers/staging/rtl8192e/rtl819x_BAProc.c:20:
  include/linux/unaligned/be_struct.h:6:19: error: redefinition of 'get_unaligned_be16'
   static inline u16 get_unaligned_be16(const void *p)
                   ^
  In file included from drivers/staging/rtl8192e/rtl819x_BAProc.c:19:0:
  include/linux/unaligned/access_ok.h:22:19: note: previous definition of 'get_unaligned_be16' was here
   static inline u16 get_unaligned_be16(const void *p)
                   ^
  ...

For independent from other include files, still suggest it includes
"asm/unaligned.h" too. And also include "asm/byteorder.h" since it is
the first include file".


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/rtl8192e/rtl819x_BAProc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl819x_BAProc.c b/drivers/staging/rtl8192e/rtl819x_BAProc.c
index 66ea791..0415e02 100644
--- a/drivers/staging/rtl8192e/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_BAProc.c
@@ -16,7 +16,8 @@
  * Contact Information:
  * wlanfae <wlanfae@realtek.com>
 ******************************************************************************/
-#include <linux/unaligned/access_ok.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include "rtllib.h"
 #include "rtl819x_BA.h"
 
-- 
1.9.3
