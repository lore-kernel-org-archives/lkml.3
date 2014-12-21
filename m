Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaLUWFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 17:05:17 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33208 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaLUWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 17:05:16 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lai Siyao <laisiyao@whamcloud.com>, Peng Tao <bergwolf@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "John L. Hammond" <john.hammond@intel.com>,
        Brian Behlendorf <behlendorf1@llnl.gov>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: llite: llite_lib.c:  Removes unnecessary NULL check
Date: Sun, 21 Dec 2014 23:08:00 +0100
Message-Id: <1419199680-13390-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes same unnecessary NULL check.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 7b6b9e2..435e1ad 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -591,10 +591,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 		get_uuid2fsid(uuid->uuid, strlen(uuid->uuid), &sbi->ll_fsid);
 	}
 
-	if (data != NULL)
-		OBD_FREE_PTR(data);
-	if (osfs != NULL)
-		OBD_FREE_PTR(osfs);
+	OBD_FREE_PTR(data);
+	OBD_FREE_PTR(osfs);
 
 	return err;
 out_root:
@@ -612,10 +610,8 @@ out_md:
 	obd_disconnect(sbi->ll_md_exp);
 	sbi->ll_md_exp = NULL;
 out:
-	if (data != NULL)
-		OBD_FREE_PTR(data);
-	if (osfs != NULL)
-		OBD_FREE_PTR(osfs);
+	OBD_FREE_PTR(data);
+	OBD_FREE_PTR(osfs);
 	lprocfs_unregister_mountpoint(sbi);
 	return err;
 }
-- 
1.7.10.4

