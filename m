Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3AYOPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:15:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3AYOO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:14:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Kevin Hilman <khilman@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: [PATCH 09/19] mfd/twl4030: don't warn about uninitialized return code
Date: Fri, 25 Jan 2013 14:14:26 +0000
Message-Id: <1359123276-15833-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ioH+4KJzdViZlGhVN6SLO/cvlpyMPvH2kx7+pz8Dr+W
 gazgGOgHCzjWY6UyGI61QXVR20fHrSl8S8Ic3jjjkDWvM2ctsO
 l2s15jqXYI/Z9FwV8phiTTlmRsRpoRzHZapqfIKQ/zmBt+Tne7
 ufQ3lzbqcc3SzV3al5GVXEmILU6A1/ftTo3k9yVkOkF9G6YbBr
 YFssqj+S3CbdKs6mY+j/dLBngeh9EwIISlF1sqeEyQ7terqcOv
 KEwlLuinKhvx460Sy9FNnz2f1Am5cp+ytDrv66S+pmcad8xoTh
 4VlKCWOkYGmPqUriP7cycMiJXqOWK1tocyK31nS5db9+a450nK
 LnsH3L3GUgSguYxr9hek7/fSzRmMFzg9WV8icoY8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the twl4030_write_script function gets called with
a zero length argument, its return value does not
get set. We know that all scripts have a nonzero
length, but returning an error in case they ever
do is probably appropriate.

Without this patch, building omap2plus_defconfig results in:

drivers/mfd/twl4030-power.c: In function 'load_twl4030_script':
drivers/mfd/twl4030-power.c:414:5: error: 'err' may be used uninitialized in this function

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
---
 drivers/mfd/twl4030-power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 4dae241..dd362c1 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -159,7 +159,7 @@ out:
 static int twl4030_write_script(u8 address, struct twl4030_ins *script,
 				       int len)
 {
-	int err;
+	int err = -EINVAL;
 
 	for (; len; len--, address++, script++) {
 		if (len == 1) {
-- 
1.8.0

