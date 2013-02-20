Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935042Ab3BTLIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:08:20 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:56333 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934990Ab3BTLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:08:19 -0500
From: Xiaotian Feng <xtfeng@gmail.com>
To: Nagalakshmi.Nandigama@lsi.com
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] mptfusion: delete rphy info in mptsas_del_end_device()
Date: Wed, 20 Feb 2013 19:09:52 +0800
Message-Id: <1361358592-13256-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, we might get wrong rphy attributes through sysfs when
a end device is not responding.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/message/fusion/mptsas.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index fa43c39..4845d18 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1572,6 +1572,8 @@ mptsas_del_end_device(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info)
 	     port->port_identifier, (unsigned long long)sas_address);
 	sas_port_delete(port);
 	mptsas_set_port(ioc, phy_info, NULL);
+	sas_rphy_delete(rphy);
+	mptsas_set_rphy(ioc, phy_info, NULL);
 	mptsas_port_delete(ioc, phy_info->port_details);
 }
 
-- 
1.7.9.5

