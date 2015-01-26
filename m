Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbbAZQws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:52:48 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60834 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbAZQwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:52:44 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com
Cc: gregkh@linuxfoundation.org, Julia.Lawall@lip6.fr, john.hammond@intel.com,
        gdonald@gmail.com, joe@perches.com, daeseok.youn@gmail.com,
        Andriy_Skulysh@xyratex.com, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: obdclass: obd_mount.c: Fix NULL dereference
Date: Mon, 26 Jan 2015 17:52:22 +0100
Message-Id: <1422291142-4451-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OBD_ALLOC_PTR(uuid) invokes kmalloc, which may return NULL. This fix
adds a check before dereferencing such pointer.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/obd_mount.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 4f39cdee..3c0c910 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -376,6 +376,11 @@ int lustre_start_mgc(struct super_block *sb)
 
 	/* Random uuid for MGC allows easier reconnects */
 	OBD_ALLOC_PTR(uuid);
+	if (!uuid) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
+
 	ll_generate_random_uuid(uuidc);
 	class_uuid_unparse(uuidc, uuid);
 
-- 
2.1.0

