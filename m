Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaC2SJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:09:34 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37559 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaC2SJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:09:30 -0400
Date: Sat, 29 Mar 2014 23:39:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 24/55] scsi: Mark functions as static in lpfc/lpfc_init.c
Message-ID: <7f50765644282cbfddc041620b3ada882eaa6524.1396114898.git.rashika.kheria@gmail.com>
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

Mark functions as static in lpfc/lpfc_init.c because they are not used
outside this file.

This eliminates the following warning in lpfc/lpfc_init.c:
drivers/scsi/lpfc/lpfc_init.c:652:1: warning: no previous prototype for ‘lpfc_hba_init_link’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_init.c:753:1: warning: no previous prototype for ‘lpfc_hba_down_link’ [-Wmissing-prototypes]
drivers/scsi/lpfc/lpfc_init.c:3434:1: warning: no previous prototype for ‘lpfc_sli4_fcf_redisc_wait_tmo’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 68c94cc..508c7b9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -648,7 +648,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
  *		0 - success
  *		Any other value - error
  **/
-int
+static int
 lpfc_hba_init_link(struct lpfc_hba *phba, uint32_t flag)
 {
 	return lpfc_hba_init_link_fc_topology(phba, phba->cfg_topology, flag);
@@ -749,7 +749,7 @@ lpfc_hba_init_link_fc_topology(struct lpfc_hba *phba, uint32_t fc_topology,
  *		0 - success
  *		Any other value - error
  **/
-int
+static int
 lpfc_hba_down_link(struct lpfc_hba *phba, uint32_t flag)
 {
 	LPFC_MBOXQ_t *pmb;
@@ -3430,7 +3430,7 @@ lpfc_fcf_redisc_wait_start_timer(struct lpfc_hba *phba)
  * list, and then worker thread shall be waked up for processing from the
  * worker thread context.
  **/
-void
+static void
 lpfc_sli4_fcf_redisc_wait_tmo(unsigned long ptr)
 {
 	struct lpfc_hba *phba = (struct lpfc_hba *)ptr;
-- 
1.7.9.5

