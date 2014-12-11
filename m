Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbaLKHVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:21:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:60858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196AbaLKHVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:21:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,556,1413270000"; 
   d="scan'208";a="622033210"
From: Kevin Strasser <kevin.strasser@intel.com>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@kernel.org>, Mengdong Lin <mengdong.lin@intel.com>,
        Yang Fang <yang.a.fang@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: Intel: fix possible acpi enumeration panic
Date: Wed, 10 Dec 2014 23:21:57 -0800
Message-Id: <1418282517-851-1-git-send-email-kevin.strasser@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A crash can occur on some platforms where adsp is enumerated but codec
is not matched. Check that the codec_id string is valid before
attempting to match.

Signed-off-by: Kevin Strasser <kevin.strasser@intel.com>
---
 sound/soc/intel/sst/sst_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/sst/sst_acpi.c b/sound/soc/intel/sst/sst_acpi.c
index 31124aa..dd72e58 100644
--- a/sound/soc/intel/sst/sst_acpi.c
+++ b/sound/soc/intel/sst/sst_acpi.c
@@ -236,7 +236,7 @@ static struct sst_machines *sst_acpi_find_machine(
 	struct sst_machines *mach;
 	bool found = false;
 
-	for (mach = machines; mach->codec_id; mach++)
+	for (mach = machines; mach->codec_id[0]; mach++)
 		if (ACPI_SUCCESS(acpi_get_devices(mach->codec_id,
 						  sst_acpi_mach_match,
 						  &found, NULL)) && found)
-- 
1.9.1

