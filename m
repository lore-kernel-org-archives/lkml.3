Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3ITWwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 18:52:33 -0400
Received: from fifo99.com ([67.223.236.141]:33019 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab3ITWwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 18:52:32 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2013 18:52:32 EDT
From: Daniel Walker <dwalker@fifo99.com>
To: Ralf Baechle <ralf@linux-mips.org>, David Daney <david.daney@cavium.com>,
        Doug Thompson <dougthompson@xmission.com>
Cc: linux-edac@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers: edac: octeon: fix lack of opstate_init
Date: Fri, 20 Sep 2013 15:46:40 -0700
Message-Id: <1379717202-26990-1-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the opstate_init() isn't called the driver won't start properly.

I just added it in what appears to be an appropriate place.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 drivers/edac/octeon_edac-lmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/edac/octeon_edac-lmc.c b/drivers/edac/octeon_edac-lmc.c
index 93412d6..4881ad0 100644
--- a/drivers/edac/octeon_edac-lmc.c
+++ b/drivers/edac/octeon_edac-lmc.c
@@ -92,6 +92,8 @@ static int octeon_lmc_edac_probe(struct platform_device *pdev)
 	struct edac_mc_layer layers[1];
 	int mc = pdev->id;
 
+	opstate_init();
+
 	layers[0].type = EDAC_MC_LAYER_CHANNEL;
 	layers[0].size = 1;
 	layers[0].is_virt_csrow = false;
-- 
1.8.1.2

