Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaGZOii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:38:38 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:33522 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaGZOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:38:36 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] scsi: ibmvscsi: ibmvscsi.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:40:02 +0200
Message-Id: <1406385602-3561-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 7b23f21..b0f5d0a 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -261,7 +261,7 @@ static void gather_partition_info(void)
 
 	ppartition_name = of_get_property(rootdn, "ibm,partition-name", NULL);
 	if (ppartition_name)
-		strncpy(partition_name, ppartition_name,
+		strlcpy(partition_name, ppartition_name,
 				sizeof(partition_name));
 	p_number_ptr = of_get_property(rootdn, "ibm,partition-no", NULL);
 	if (p_number_ptr)
@@ -277,7 +277,7 @@ static void set_adapter_info(struct ibmvscsi_host_data *hostdata)
 	dev_info(hostdata->dev, "SRP_VERSION: %s\n", SRP_VERSION);
 	strcpy(hostdata->madapter_info.srp_version, SRP_VERSION);
 
-	strncpy(hostdata->madapter_info.partition_name, partition_name,
+	strlcpy(hostdata->madapter_info.partition_name, partition_name,
 			sizeof(hostdata->madapter_info.partition_name));
 
 	hostdata->madapter_info.partition_number =
@@ -1280,8 +1280,7 @@ static void send_mad_capabilities(struct ibmvscsi_host_data *hostdata)
 
 	location = of_get_property(of_node, "ibm,loc-code", NULL);
 	location = location ? location : dev_name(hostdata->dev);
-	strncpy(hostdata->caps.loc, location, sizeof(hostdata->caps.loc));
-	hostdata->caps.loc[sizeof(hostdata->caps.loc) - 1] = '\0';
+	strlcpy(hostdata->caps.loc, location, sizeof(hostdata->caps.loc));
 
 	req->common.type = cpu_to_be32(VIOSRP_CAPABILITIES_TYPE);
 	req->buffer = cpu_to_be64(hostdata->caps_addr);
-- 
1.7.10.4

