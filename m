Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaC2Sje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:39:34 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60710 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaC2Sja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:39:30 -0400
Date: Sun, 30 Mar 2014 00:09:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        iss_storagedev@hp.com, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 45/55] scsi: Mark funtion as static in hpsa.c
Message-ID: <43d1f6881b0323ae26b126b5b31b4884aa8f6b0f.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in hpsa.c because it is not used outside this
file.

This eliminates the following warning in hpsa.c:
drivers/scsi/hpsa.c:1925:5: warning: no previous prototype for ‘figure_lunaddrbytes’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/hpsa.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 868318a..025dc8e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1922,8 +1922,9 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	return 0;
 }
 
-u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, int i,
-	int nphysicals, int nlogicals, struct ReportLUNdata *physdev_list,
+static u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position,
+	int i, int nphysicals, int nlogicals,
+	struct ReportLUNdata *physdev_list,
 	struct ReportLUNdata *logdev_list)
 {
 	/* Helper function, figure out where the LUN ID info is coming from
-- 
1.7.9.5

