Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaC2SbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:31:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63353 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaC2SbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:31:21 -0400
Date: Sun, 30 Mar 2014 00:01:46 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 41/55] scsi: Mark functions as static in qla2xxx/qla_nx2.c
Message-ID: <042ce390a93d61cce34549749d9afa9eb570e910.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in qla2xxx/qla_nx2.c because they are not used
outside this file.

This eliminates the following warning in qla2xxx/qla_nx2.c:
drivers/scsi/qla2xxx/qla_nx2.c:473:1: warning: no previous prototype for ‘qla8044_need_reset’ [-Wmissing-prototypes]
drivers/scsi/qla2xxx/qla_nx2.c:1517:1: warning: no previous prototype for ‘qla8044_set_rst_ready’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/qla2xxx/qla_nx2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index f60989d..02584e7 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -469,7 +469,7 @@ qla8044_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 	return buf;
 }
 
-inline int
+static inline int
 qla8044_need_reset(struct scsi_qla_host *vha)
 {
 	uint32_t drv_state, drv_active;
@@ -1513,7 +1513,7 @@ qla8044_set_idc_dontreset(struct scsi_qla_host *vha)
 	qla8044_wr_reg(ha, QLA8044_IDC_DRV_CTRL, idc_ctrl);
 }
 
-inline void
+static inline void
 qla8044_set_rst_ready(struct scsi_qla_host *vha)
 {
 	uint32_t drv_state;
-- 
1.7.9.5

