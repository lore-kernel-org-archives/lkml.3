Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaC2Sc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:32:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43238 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaC2Sc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:32:26 -0400
Date: Sun, 30 Mar 2014 00:02:51 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 42/55] scsi: Mark function as static in scsi_transport_fc.c
Message-ID: <37fd6c59540600548392b82debb4513e858aebd1.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in scsi_transport_fc.c because it is not used
outside this file.

This eliminates the following warning in scsi_transport_fc.c:
drivers/scsi/scsi_transport_fc.c:2025:5: warning: no previous prototype for ‘scsi_is_fc_vport’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/scsi_transport_fc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4628fd5..7c01007 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2022,11 +2022,10 @@ static void fc_vport_dev_release(struct device *dev)
 	kfree(vport);
 }
 
-int scsi_is_fc_vport(const struct device *dev)
+static int scsi_is_fc_vport(const struct device *dev)
 {
 	return dev->release == fc_vport_dev_release;
 }
-EXPORT_SYMBOL(scsi_is_fc_vport);
 
 static int fc_vport_match(struct attribute_container *cont,
 			    struct device *dev)
-- 
1.7.9.5

