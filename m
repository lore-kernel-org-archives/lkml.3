Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaC2S2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:28:06 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40258 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaC2S2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:28:03 -0400
Date: Sat, 29 Mar 2014 23:58:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 39/55] scsi: Mark functions as static in qla2xxx/qla_iocb.c
Message-ID: <52c3b0cf7c2d793945554277be595fa2ea88b984.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in qla2xxx/qla_iocb.c because they are not used
outside this file.

This eliminates the following warning in qla2xxx/qla_iocb.c:
drivers/scsi/qla2xxx/qla_iocb.c:714:1: warning: no previous prototype for ‘qla24xx_calc_dsd_lists’ [-Wmissing-prototypes]
drivers/scsi/qla2xxx/qla_iocb.c:734:1: warning: no previous prototype for ‘qla24xx_build_scsi_iocbs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 46b9307..2629477 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -710,7 +710,7 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
  *
  * Returns the number of dsd list needed to store @dsds.
  */
-inline uint16_t
+static inline uint16_t
 qla24xx_calc_dsd_lists(uint16_t dsds)
 {
 	uint16_t dsd_lists = 0;
@@ -730,7 +730,7 @@ qla24xx_calc_dsd_lists(uint16_t dsds)
  * @cmd_pkt: Command type 3 IOCB
  * @tot_dsds: Total number of segments to transfer
  */
-inline void
+static inline void
 qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
     uint16_t tot_dsds)
 {
-- 
1.7.9.5

