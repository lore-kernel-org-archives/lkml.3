Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaBDHBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 02:01:02 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59164 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaBDHAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 02:00:55 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org, dulshani.gunawardhana89@gmail.com,
        shaun@XResource.ca, lisa@xenapiadmin.com, sima.baymani@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] staging: cxt1e1: fix pointer-integer size mismatch warning
Date: Tue,  4 Feb 2014 16:01:26 +0900
Message-Id: <1391497286-6951-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the pointer-integer size mismatch warning below:
	drivers/staging/cxt1e1/functions.c: In function ‘VMETRO_TRACE’:
	drivers/staging/cxt1e1/functions.c:268:21: warning: cast from pointer
			to integer of different size [-Wpointer-to-int-cast]
	     u_int32_t   y = (u_int32_t) x;
			     ^

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/cxt1e1/functions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/cxt1e1/functions.c b/drivers/staging/cxt1e1/functions.c
index 95218e2..8f19a39 100644
--- a/drivers/staging/cxt1e1/functions.c
+++ b/drivers/staging/cxt1e1/functions.c
@@ -265,7 +265,7 @@ extern ci_t *CI;                /* dummy pointer to board ZERO's data */
 void
 VMETRO_TRACE (void *x)
 {
-    u_int32_t   y = (u_int32_t) x;
+    u_int32_t   y = (u_int32_t)(uintptr_t) x;
 
     pci_write_32 ((u_int32_t *) &CI->cpldbase->leds, y);
 }
-- 
1.8.3.2

