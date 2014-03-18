Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbaCRWd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:33:56 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40787 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbaCRWdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:33:53 -0400
From: Matei Oprea <eu@opreamatei.ro>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, shaun@xresource.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: [PATCH] staging: cxt1e1: hwprobe: Fix sparse warning
Date: Wed, 19 Mar 2014 00:33:19 +0200
Message-Id: <1395181999-29433-1-git-send-email-eu@opreamatei.ro>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warning:
* drivers/staging/cxt1e1/hwprobe.c:43:19: 
warning: symbol 'hdw_info' was not declared. Should it be static?
* drivers/staging/cxt1e1/hwprobe.c:47:1: 
warning: symbol 'show_two' was not declared. Should it be static?
* drivers/staging/cxt1e1/hwprobe.c:99:1: 
warning: symbol 'hdw_sn_get' was not declared. Should it be static?
*drivers/staging/cxt1e1/hwprobe.c:149:1: 
warning: symbol 'prep_hdw_info' was not declared. Should it be static?
* drivers/staging/cxt1e1/hwprobe.c:169:1: 
warning: symbol 'cleanup_ioremap' was not declared. Should it be static?
* drivers/staging/cxt1e1/hwprobe.c:195:1: 
warning: symbol 'cleanup_devs' was not declared. Should it be static?
drivers/staging/cxt1e1/hwprobe.c:293:1: 
* warning: symbol 'c4hw_attach_all' was not declared. Should it be static?

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/staging/cxt1e1/hwprobe.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 02b4f8f..694047a 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -40,10 +40,10 @@ void        c4_stopwd (ci_t *);
 struct net_device * __init c4_add_dev (hdw_info_t *, int, unsigned long, unsigned long, int, int);
 
 
-struct s_hdw_info hdw_info[MAX_BOARDS];
+static struct s_hdw_info hdw_info[MAX_BOARDS];
 
 
-void        __init
+static void        __init
 show_two (hdw_info_t *hi, int brdno)
 {
     ci_t       *ci;
@@ -95,7 +95,7 @@ show_two (hdw_info_t *hi, int brdno)
 }
 
 
-void        __init
+static void        __init
 hdw_sn_get (hdw_info_t *hi, int brdno)
 {
     /* obtain hardware EEPROM information */
@@ -145,7 +145,7 @@ hdw_sn_get (hdw_info_t *hi, int brdno)
 }
 
 
-void        __init
+static void        __init
 prep_hdw_info (void)
 {
     hdw_info_t *hi;
@@ -165,7 +165,7 @@ prep_hdw_info (void)
     }
 }
 
-void
+static void
 cleanup_ioremap (void)
 {
     hdw_info_t *hi;
@@ -191,7 +191,7 @@ cleanup_ioremap (void)
 }
 
 
-void
+static void
 cleanup_devs (void)
 {
     hdw_info_t *hi;
@@ -289,7 +289,7 @@ c4_hdw_init (struct pci_dev *pdev, int found)
 }
 
 
-status_t    __init
+static status_t    __init
 c4hw_attach_all (void)
 {
     hdw_info_t *hi;
-- 
1.7.9.5

