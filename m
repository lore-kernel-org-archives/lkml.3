Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaG3WOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:14:43 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:47750 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaG3WOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:14:35 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Brian King <brking@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] scsi: ibmvscsi: ibmvfc.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Thu, 31 Jul 2014 00:15:59 +0200
Message-Id: <1406758559-20836-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406758559-20836-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406758559-20836-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 8dd4768..56c26ef 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1149,7 +1149,8 @@ static void ibmvfc_gather_partition_info(struct ibmvfc_host *vhost)
 
 	name = of_get_property(rootdn, "ibm,partition-name", NULL);
 	if (name)
-		strncpy(vhost->partition_name, name, sizeof(vhost->partition_name));
+		strlcpy(vhost->partition_name, name,
+				sizeof(vhost->partition_name));
 	num = of_get_property(rootdn, "ibm,partition-no", NULL);
 	if (num)
 		vhost->partition_number = *num;
@@ -1186,13 +1187,14 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	login_info->capabilities = IBMVFC_CAN_MIGRATE;
 	login_info->async.va = vhost->async_crq.msg_token;
 	login_info->async.len = vhost->async_crq.size * sizeof(*vhost->async_crq.msgs);
-	strncpy(login_info->partition_name, vhost->partition_name, IBMVFC_MAX_NAME);
-	strncpy(login_info->device_name,
+	strlcpy(login_info->partition_name, vhost->partition_name,
+			IBMVFC_MAX_NAME);
+	strlcpy(login_info->device_name,
 		dev_name(&vhost->host->shost_gendev), IBMVFC_MAX_NAME);
 
 	location = of_get_property(of_node, "ibm,loc-code", NULL);
 	location = location ? location : dev_name(vhost->dev);
-	strncpy(login_info->drc_name, location, IBMVFC_MAX_NAME);
+	strlcpy(login_info->drc_name, location, IBMVFC_MAX_NAME);
 }
 
 /**
-- 
1.7.10.4

