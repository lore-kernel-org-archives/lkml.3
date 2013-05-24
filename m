Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab3EXCXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 22:23:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:54239 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab3EXCXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 22:23:49 -0400
Message-ID: <519ECEF1.9060804@huawei.com>
Date: Fri, 24 May 2013 10:22:41 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <megaraidlinux@lsi.com>, <JBottomley@parallels.com>
CC: <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <kashyap.desai@lsi.com>, <aradford@gmail.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] scsi: megaraid: check kzalloc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we should check kzalloc, avoid to hit oops

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/scsi/megaraid.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 846f475..195b095 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4162,6 +4162,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)

 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
 	scmd->device = sdev;
+	if (!scmd->device) {
+		scsi_free_command(GFP_KERNEL, scmd);
+		return -ENOMEM;
+	}

 	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
 	scmd->cmnd = adapter->int_cdb;
-- 
1.7.1

