Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab3FNCkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:40:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57445 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759888Ab3FNCkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:40:35 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 16/33] scsi_sysctl: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:41 -0700
Message-Id: <adabcc42505e0e6c62f31a582386b8d0d4d28f6e.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/scsi_sysctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 2b6b93f..546f162 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -12,7 +12,7 @@
 #include "scsi_priv.h"
 
 
-static ctl_table scsi_table[] = {
+static struct ctl_table scsi_table[] = {
 	{ .procname	= "logging_level",
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
@@ -21,14 +21,14 @@ static ctl_table scsi_table[] = {
 	{ }
 };
 
-static ctl_table scsi_dir_table[] = {
+static struct ctl_table scsi_dir_table[] = {
 	{ .procname	= "scsi",
 	  .mode		= 0555,
 	  .child	= scsi_table },
 	{ }
 };
 
-static ctl_table scsi_root_table[] = {
+static struct ctl_table scsi_root_table[] = {
 	{ .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= scsi_dir_table },
-- 
1.8.1.2.459.gbcd45b4.dirty

