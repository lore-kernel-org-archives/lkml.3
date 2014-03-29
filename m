Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaC2RmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:42:21 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33475 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaC2RmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:42:19 -0400
Date: Sat, 29 Mar 2014 23:12:42 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 01/55] scsi: Mark function as static in aacraid/src.c
Message-ID: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in aacraid/src.c because it is not used outside
this file.

This eliminates the following warning in aacraid/src.c:
drivers/scsi/aacraid/src.c:526:5: warning: no previous prototype for ‘aac_src_select_comm’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/aacraid/src.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 7e17107..46b1252 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -523,7 +523,7 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
  *	@dev: Adapter
  *	@comm: communications method
  */
-int aac_src_select_comm(struct aac_dev *dev, int comm)
+static int aac_src_select_comm(struct aac_dev *dev, int comm)
 {
 	switch (comm) {
 	case AAC_COMM_MESSAGE:
-- 
1.7.9.5

