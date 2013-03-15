Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab3COSVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:21:10 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:65425 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3COSVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:21:08 -0400
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: zbr@ioremap.net, olivier@okprods.com,
        Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: [PATCH 2/2] w1: ds2408: use ARRAY_SIZE instead of hard-coded number
Date: Fri, 15 Mar 2013 14:20:26 -0400
Message-Id: <1363371626-3624-2-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1363371626-3624-1-git-send-email-jeff.dagenais@gmail.com>
References: <20130315001550.GA3144@ioremap.net>
 <1363371626-3624-1-git-send-email-jeff.dagenais@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
---
 drivers/w1/slaves/w1_ds2408.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index 25a5168..e45eca1 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -303,8 +303,7 @@ error:
 
 
 
-#define NB_SYSFS_BIN_FILES 6
-static struct bin_attribute w1_f29_sysfs_bin_files[NB_SYSFS_BIN_FILES] = {
+static struct bin_attribute w1_f29_sysfs_bin_files[] = {
 	{
 		.attr =	{
 			.name = "state",
@@ -363,7 +362,7 @@ static int w1_f29_add_slave(struct w1_slave *sl)
 	int err = 0;
 	int i;
 
-	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
+	for (i = 0; i < ARRAY_SIZE(w1_f29_sysfs_bin_files) && !err; ++i)
 		err = sysfs_create_bin_file(
 			&sl->dev.kobj,
 			&(w1_f29_sysfs_bin_files[i]));
@@ -377,7 +376,7 @@ static int w1_f29_add_slave(struct w1_slave *sl)
 static void w1_f29_remove_slave(struct w1_slave *sl)
 {
 	int i;
-	for (i = NB_SYSFS_BIN_FILES - 1; i >= 0; --i)
+	for (i = ARRAY_SIZE(w1_f29_sysfs_bin_files) - 1; i >= 0; --i)
 		sysfs_remove_bin_file(&sl->dev.kobj,
 			&(w1_f29_sysfs_bin_files[i]));
 }
-- 
1.8.1.1

