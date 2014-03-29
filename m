Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaC2Sfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:35:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52362 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaC2Sfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:35:32 -0400
Date: Sun, 30 Mar 2014 00:05:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 43/55] scsi: Mark function as static in scsi_transport_iscsi.c
Message-ID: <eef277e596edf0e016d18543fe1638148c775ff8.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in scsi_transport_iscsi.c because it is not used
outside this file. Also, unexport the function since it's only used in
this file.

This eliminates the following warning in scsi_transport_iscsi.c:
drivers/scsi/scsi_transport_iscsi.c:1325:5: warning: no previous prototype for ‘iscsi_is_flashnode_conn_dev’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/scsi_transport_iscsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fd8ffe6..5b6185e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1322,11 +1322,10 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
  *  1 on success
  *  0 on failure
  */
-int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
+static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
 {
 	return dev->bus == &iscsi_flashnode_bus;
 }
-EXPORT_SYMBOL_GPL(iscsi_is_flashnode_conn_dev);
 
 static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
 {
-- 
1.7.9.5

