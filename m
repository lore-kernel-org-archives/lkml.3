Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3KUOnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:43:04 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52761 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KUOnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:43:01 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 2/2] staging/lustre/obdclass: add empty tailing member to ctl_table
Date: Thu, 21 Nov 2013 22:42:46 +0800
Message-Id: <1385044966-3572-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044966-3572-1-git-send-email-bergwolf@gmail.com>
References: <1385044966-3572-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was mistakenly removed by commit 7fb3d1c5.
Now register_sysctl_table() complains about "No proc_handler".

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
index d66be02..c1ef0c9 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c
@@ -392,7 +392,8 @@ static ctl_table_t obd_table[] = {
 		.maxlen   = sizeof(int),
 		.mode     = 0644,
 		.proc_handler = &proc_at_history
-	}
+	},
+	{}
 };
 
 static ctl_table_t parent_table[] = {
@@ -402,7 +403,8 @@ static ctl_table_t parent_table[] = {
 		.maxlen   = 0,
 		.mode     = 0555,
 		.child    = obd_table
-	}
+	},
+	{}
 };
 #endif
 
-- 
1.7.9.5

