Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbaFUDGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 23:06:46 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:37091 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaFUDGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 23:06:45 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: vt6655: remove header declarations for static functions
Date: Fri, 20 Jun 2014 23:06:11 -0400
Message-Id: <1403319971-13621-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions iwctl_giwscan() and iwctl_siwscan() are only referenced
within iwctl.c -- so, remove their function declarations from iwctl.h
and mark these functions as static.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/vt6655/iwctl.c |    4 ++--
 drivers/staging/vt6655/iwctl.h |   10 ----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index ba50d7f..747d723 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -129,7 +129,7 @@ int iwctl_giwname(struct net_device *dev,
  * Wireless Handler : set scan
  */
 
-int iwctl_siwscan(struct net_device *dev,
+static int iwctl_siwscan(struct net_device *dev,
 		  struct iw_request_info *info,
 		  struct iw_point *wrq,
 		  char *extra)
@@ -190,7 +190,7 @@ int iwctl_siwscan(struct net_device *dev,
  * Wireless Handler : get scan results
  */
 
-int iwctl_giwscan(struct net_device *dev,
+static int iwctl_giwscan(struct net_device *dev,
 		  struct iw_request_info *info,
 		  struct iw_point *wrq,
 		  char *extra)
diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
index 10564b4..de0a337 100644
--- a/drivers/staging/vt6655/iwctl.h
+++ b/drivers/staging/vt6655/iwctl.h
@@ -161,16 +161,6 @@ int iwctl_giwpower(struct net_device *dev,
 		   struct iw_param *wrq,
 		   char *extra);
 
-int iwctl_giwscan(struct net_device *dev,
-		  struct iw_request_info *info,
-		  struct iw_point *wrq,
-		  char *extra);
-
-int iwctl_siwscan(struct net_device *dev,
-		  struct iw_request_info *info,
-		  struct iw_point *wrq,
-		  char *extra);
-
 //2008-0409-07, <Add> by Einsn Liu
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 int iwctl_siwauth(struct net_device *dev,
-- 
1.7.9.5

