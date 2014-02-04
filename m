Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaBDIgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:36:16 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59880 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaBDIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:36:11 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org, dulshani.gunawardhana89@gmail.com,
        shaun@XResource.ca, lisa@xenapiadmin.com, sima.baymani@gmail.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] staging: cxt1e1: remove unnecessary function, VMETRO_TRACE
Date: Tue,  4 Feb 2014 17:36:39 +0900
Message-Id: <1391502999-7349-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMETRO_TRACE isn't called from anywhere. So delete it.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/cxt1e1/functions.c | 9 ---------
 drivers/staging/cxt1e1/pmcc4.h     | 1 -
 2 files changed, 10 deletions(-)

diff --git a/drivers/staging/cxt1e1/functions.c b/drivers/staging/cxt1e1/functions.c
index 95218e2..f5ce852 100644
--- a/drivers/staging/cxt1e1/functions.c
+++ b/drivers/staging/cxt1e1/functions.c
@@ -263,15 +263,6 @@ void sd_recv_consume(void *token, size_t len, void *user)
 
 extern ci_t *CI;                /* dummy pointer to board ZERO's data */
 void
-VMETRO_TRACE (void *x)
-{
-    u_int32_t   y = (u_int32_t) x;
-
-    pci_write_32 ((u_int32_t *) &CI->cpldbase->leds, y);
-}
-
-
-void
 VMETRO_TRIGGER (ci_t *ci, int x)
 {
     struct s_comet_reg    *comet;
diff --git a/drivers/staging/cxt1e1/pmcc4.h b/drivers/staging/cxt1e1/pmcc4.h
index 003eb86..b4b5e5a 100644
--- a/drivers/staging/cxt1e1/pmcc4.h
+++ b/drivers/staging/cxt1e1/pmcc4.h
@@ -96,7 +96,6 @@ void        sbeid_set_bdtype (ci_t *ci);
 void        sbeid_set_hdwbid (ci_t *ci);
 u_int32_t   sbeCrc (u_int8_t *, u_int32_t, u_int32_t, u_int32_t *);
 
-void        VMETRO_TRACE (void *);       /* put data into 8 LEDs */
 void        VMETRO_TRIGGER (ci_t *, int);       /* Note: int = 0(default)
                                                  * thru 15 */
 
-- 
1.8.3.2

