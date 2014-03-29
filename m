Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaC2Ska (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:40:30 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57083 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaC2Sk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:40:28 -0400
Date: Sun, 30 Mar 2014 00:10:53 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Achim Leubner <achim_leubner@adaptec.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 46/55] scsi: Mark functions as static in gdth.c
Message-ID: <0474b98580d0837b5906973b5d9599c9a9c526b6.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in gdth.c because they are not used outside
this file.

This eliminates the following warnings in gdth.c:
drivers/scsi/gdth.c:445:5: warning: no previous prototype for ‘__gdth_execute’ [-Wmissing-prototypes]
drivers/scsi/gdth.c:3830:12: warning: no previous prototype for ‘option_setup’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/gdth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index ce5ef01..8015f1b 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -442,8 +442,8 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
 		scp->scsi_done(scp);
 }
 
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
-                   int timeout, u32 *info)
+static int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd,
+			  char *cmnd, int timeout, u32 *info)
 {
     gdth_ha_str *ha = shost_priv(sdev->host);
     Scsi_Cmnd *scp;
@@ -3827,7 +3827,7 @@ static void __init internal_setup(char *str,int *ints)
     }
 }
 
-int __init option_setup(char *str)
+static int __init option_setup(char *str)
 {
     int ints[MAXHA];
     char *cur = str;
-- 
1.7.9.5

