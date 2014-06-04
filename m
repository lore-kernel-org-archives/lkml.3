Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaFDVdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:33:43 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51571 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFDVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:33:41 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Robert Jennings <rcj@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] scsi: ibmvscsi: ibmvscsi.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:34:35 +0200
Message-Id: <1401917675-3044-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index fa76440..e214f9e 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -250,9 +250,11 @@ static void gather_partition_info(void)
 	}
 
 	ppartition_name = of_get_property(rootdn, "ibm,partition-name", NULL);
-	if (ppartition_name)
+	if (ppartition_name) {
 		strncpy(partition_name, ppartition_name,
 				sizeof(partition_name));
+		partition_name[sizeof(partition_name) - 1] = '\0';
+	}
 	p_number_ptr = of_get_property(rootdn, "ibm,partition-no", NULL);
 	if (p_number_ptr)
 		partition_number = of_read_number(p_number_ptr, 1);
-- 
1.7.10.4

