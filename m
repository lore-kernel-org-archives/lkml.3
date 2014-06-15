Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaFOUjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:39:18 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:40131 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752768AbaFOUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:39:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:4321:5007:6261:8957:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wind25_6c484ff1f2e1d
X-Filterd-Recvd-Size: 2144
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH -next 20/26] megaraid: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:49 -0700
Message-Id: <c984d1be8d1f03baa81f4d1d319d1de8d51688f1.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2260041..1b18010 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -608,10 +608,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		goto fail_get_cmd;
 	}
 
-	IOCInitMessage =
-	  dma_alloc_coherent(&instance->pdev->dev,
-			     sizeof(struct MPI2_IOC_INIT_REQUEST),
-			     &ioc_init_handle, GFP_KERNEL);
+	IOCInitMessage = dma_zalloc_coherent(&instance->pdev->dev,
+					     sizeof(struct MPI2_IOC_INIT_REQUEST),
+					     &ioc_init_handle, GFP_KERNEL);
 
 	if (!IOCInitMessage) {
 		printk(KERN_ERR "Could not allocate memory for "
@@ -620,8 +619,6 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		goto fail_fw_init;
 	}
 
-	memset(IOCInitMessage, 0, sizeof(struct MPI2_IOC_INIT_REQUEST));
-
 	IOCInitMessage->Function = MPI2_FUNCTION_IOC_INIT;
 	IOCInitMessage->WhoInit	= MPI2_WHOINIT_HOST_DRIVER;
 	IOCInitMessage->MsgVersion = cpu_to_le16(MPI2_VERSION);
-- 
1.8.1.2.459.gbcd45b4.dirty

