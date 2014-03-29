Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaC2SBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:01:44 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36417 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaC2SBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:01:42 -0400
Date: Sat, 29 Mar 2014 23:32:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 17/55] scsi: Mark function as static in cxgbi/cxgb3i/cxgb3i.c
Message-ID: <93a0ea231762420bb9f6ba69c08e83cb905ce79c.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in cxgbi/cxgb3i/cxgb3i.c because it is not used
outside this file.

This eliminates the following warning in cxgbi/cxgb3i/cxgb3i.c:
drivers/scsi/cxgbi/cxgb3i/cxgb3i.c:1028:5: warning: no previous prototype for ‘cxgb3i_ofld_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 49692a1..6de59c5 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1025,7 +1025,7 @@ cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS] = {
  * cxgb3i_ofld_init - allocate and initialize resources for each adapter found
  * @cdev:	cxgbi adapter
  */
-int cxgb3i_ofld_init(struct cxgbi_device *cdev)
+static int cxgb3i_ofld_init(struct cxgbi_device *cdev)
 {
 	struct t3cdev *t3dev = (struct t3cdev *)cdev->lldev;
 	struct adap_ports port;
-- 
1.7.9.5

