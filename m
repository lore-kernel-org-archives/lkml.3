Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab3LRSdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:33:08 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57148 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3LRSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:33:05 -0500
Date: Thu, 19 Dec 2013 00:02:54 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>,
        Joern Engel <joern@logfs.org>,
        Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 3/4] drivers: target: Mark functions as static in tcm_loop.c
Message-ID: <6d957ed9181ac274d13385db204db100b0ef8416.1387390091.git.rashika.kheria@gmail.com>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions tcm_loop_make_naa_tpg(), tcm_loop_drop_naa_tpg(),
tcm_loop_make_scsi_hba() and tcm_loop_drop_scsi_hba() as static in
loopback/tcm_loop.c because they are not used outside this file.

This eliminates the following warning in loopback/tcm_loop.c:
drivers/target/loopback/tcm_loop.c:1231:25: warning: no previous prototype for ‘tcm_loop_make_naa_tpg’ [-Wmissing-prototypes]
drivers/target/loopback/tcm_loop.c:1276:6: warning: no previous prototype for ‘tcm_loop_drop_naa_tpg’ [-Wmissing-prototypes]
drivers/target/loopback/tcm_loop.c:1308:16: warning: no previous prototype for ‘tcm_loop_make_scsi_hba’ [-Wmissing-prototypes]
drivers/target/loopback/tcm_loop.c:1378:6: warning: no previous prototype for ‘tcm_loop_drop_scsi_hba’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/target/loopback/tcm_loop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 1b41e67..763ee45 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1228,7 +1228,7 @@ static struct configfs_attribute *tcm_loop_tpg_attrs[] = {
 
 /* Start items for tcm_loop_naa_cit */
 
-struct se_portal_group *tcm_loop_make_naa_tpg(
+static struct se_portal_group *tcm_loop_make_naa_tpg(
 	struct se_wwn *wwn,
 	struct config_group *group,
 	const char *name)
@@ -1273,7 +1273,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
 	return &tl_tpg->tl_se_tpg;
 }
 
-void tcm_loop_drop_naa_tpg(
+static void tcm_loop_drop_naa_tpg(
 	struct se_portal_group *se_tpg)
 {
 	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
@@ -1305,7 +1305,7 @@ void tcm_loop_drop_naa_tpg(
 
 /* Start items for tcm_loop_cit */
 
-struct se_wwn *tcm_loop_make_scsi_hba(
+static struct se_wwn *tcm_loop_make_scsi_hba(
 	struct target_fabric_configfs *tf,
 	struct config_group *group,
 	const char *name)
@@ -1375,7 +1375,7 @@ out:
 	return ERR_PTR(ret);
 }
 
-void tcm_loop_drop_scsi_hba(
+static void tcm_loop_drop_scsi_hba(
 	struct se_wwn *wwn)
 {
 	struct tcm_loop_hba *tl_hba = container_of(wwn,
-- 
1.7.9.5

