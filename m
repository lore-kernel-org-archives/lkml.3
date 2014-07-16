Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaGPXD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:03:56 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:51704 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaGPXDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:03:52 -0400
From: Josep Puigdemont <josep.puigdemont@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Josep Puigdemont <josep.puigdemont@gmail.com>
Subject: [PATCH] lustre: plain interger was used as NULL pointer
Date: Thu, 17 Jul 2014 01:03:39 +0200
Message-Id: <1405551819-2699-1-git-send-email-josep.puigdemont@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warnings found when running sparse:
.../lproc_echo.c:43:11: warning: Using plain integer as NULL pointer
.../lproc_echo.c:49:11: warning: Using plain integer as NULL pointer

Signed-off-by: Josep Puigdemont <josep.puigdemont@gmail.com>
---
 drivers/staging/lustre/lustre/obdecho/lproc_echo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdecho/lproc_echo.c b/drivers/staging/lustre/lustre/obdecho/lproc_echo.c
index 487c4f3..1d3bf6c 100644
--- a/drivers/staging/lustre/lustre/obdecho/lproc_echo.c
+++ b/drivers/staging/lustre/lustre/obdecho/lproc_echo.c
@@ -40,13 +40,13 @@
 LPROC_SEQ_FOPS_RO_TYPE(echo, uuid);
 static struct lprocfs_vars lprocfs_echo_obd_vars[] = {
 	{ "uuid",	 &echo_uuid_fops,	NULL, 0 },
-	{ 0 }
+	{ NULL }
 };
 
 LPROC_SEQ_FOPS_RO_TYPE(echo, numrefs);
 static struct lprocfs_vars lprocfs_echo_module_vars[] = {
 	{ "num_refs",     &echo_numrefs_fops,     NULL, 0 },
-	{ 0 }
+	{ NULL }
 };
 
 void lprocfs_echo_init_vars(struct lprocfs_static_vars *lvars)
-- 
1.9.3

