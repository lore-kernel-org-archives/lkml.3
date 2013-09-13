Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3IMAEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:04:38 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36621 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780Ab3IMAEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:04:35 -0400
X-Sasl-enc: zTjs19mg5B6eX5TQI8NSpizylSFWK49uICM/ZvOASlgS 1379030674
From: Jon Bernard <jbernard@tuxion.com>
To: gregkh@linuxfoundation.org, tao.peng@emc.com, andreas.dilger@intel.com,
        jencce.kernel@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH] Staging: lustre: fix assignment in if condition in fsfilt.c
Date: Thu, 12 Sep 2013 20:04:33 -0400
Message-Id: <1379030673-58859-1-git-send-email-jbernard@tuxion.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the fsfilt.c file that fixes up three assignment in if
condition errors found by the checkpatch.pl tool.

Signed-off-by: Jon Bernard <jbernard@tuxion.com>
---
 drivers/staging/lustre/lustre/lvfs/fsfilt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lvfs/fsfilt.c b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
index efc1e52..0d6ed69 100644
--- a/drivers/staging/lustre/lustre/lvfs/fsfilt.c
+++ b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
@@ -61,7 +61,8 @@ int fsfilt_register_ops(struct fsfilt_operations *fs_ops)
 	struct fsfilt_operations *found;
 
 	/* lock fsfilt_types list */
-	if ((found = fsfilt_search_type(fs_ops->fs_type))) {
+	found = fsfilt_search_type(fs_ops->fs_type);
+	if (found) {
 		if (found != fs_ops) {
 			CERROR("different operations for type %s\n",
 			       fs_ops->fs_type);
@@ -102,14 +103,16 @@ struct fsfilt_operations *fsfilt_get_ops(const char *type)
 	struct fsfilt_operations *fs_ops;
 
 	/* lock fsfilt_types list */
-	if (!(fs_ops = fsfilt_search_type(type))) {
+	fs_ops = fsfilt_search_type(type);
+	if (!fs_ops) {
 		char name[32];
 		int rc;
 
 		snprintf(name, sizeof(name) - 1, "fsfilt_%s", type);
 		name[sizeof(name) - 1] = '\0';
 
-		if (!(rc = request_module("%s", name))) {
+		rc = request_module("%s", name);
+		if (!rc) {
 			fs_ops = fsfilt_search_type(type);
 			CDEBUG(D_INFO, "Loaded module '%s'\n", name);
 			if (!fs_ops)
-- 
1.8.4

