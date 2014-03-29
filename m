Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaC2Q3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 12:29:37 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41300 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaC2Q3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 12:29:35 -0400
Date: Sat, 29 Mar 2014 22:00:00 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 02/55] scsi: Mark function as static in be2iscsi/be_cmds.c
Message-ID: <e8c6c765e48ea867376850f1bc693f797fa14a53.1394382962.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1394382962.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1394382962.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in be2iscsi/be_cmds.c because it is not used
outside this file.

This eliminates the following warning in be2iscsi/be_cmds.c:
drivers/scsi/be2iscsi/be_cmds.c:401:5: warning: no previous prototype for ‘beiscsi_process_mcc’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 3338391..026c3e3 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -398,7 +398,7 @@ static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,
 }
 
 
-int beiscsi_process_mcc(struct beiscsi_hba *phba)
+static int beiscsi_process_mcc(struct beiscsi_hba *phba)
 {
 	struct be_mcc_compl *compl;
 	int num = 0, status = 0;
-- 
1.7.9.5

