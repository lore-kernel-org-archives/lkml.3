Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaCHS7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 13:59:06 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:41277 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaCHS6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 13:58:24 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/4] megaraid: Downgrade success messages from KERN_ERR to dev_dbg
Date: Sat,  8 Mar 2014 10:58:13 -0800
Message-Id: <5f7f702c58631462bc23d3787a6d515942ca24f6.1394304585.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
In-Reply-To: <cover.1394304585.git.luto@amacapital.net>
References: <cover.1394304585.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These messages are uninteresting indications of success.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3b7ad10..a0a133d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3755,7 +3755,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
 
-	printk(KERN_ERR "megasas: INIT adapter done\n");
+	dev_dbg(&instance->pdev->dev, "INIT adapter done\n");
 
 	/** for passthrough
 	* the following function will get the PD LIST.
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f655592..261742a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -679,7 +679,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		ret = 1;
 		goto fail_fw_init;
 	}
-	printk(KERN_ERR "megasas:IOC Init cmd success\n");
+	dev_dbg(&instance->pdev->dev, "IOC Init cmd success\n");
 
 	ret = 0;
 
-- 
1.8.5.3

