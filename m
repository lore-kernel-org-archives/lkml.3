Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbaLBR7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:59:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:41063 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbaLBR66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:58:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="492404943"
From: Tony Luck <tony.luck@intel.com>
Date: Tue, 2 Dec 2014 09:41:58 -0800
Subject: [PATCH] sb_edac: Fix typo computing number of banks
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@alien8.de>,
        Aristeu Rozanski <aris@redhat.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <088380@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code will always think there are 16 banks because of a typo

Reported-by: Misha
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Not sure if Misha is shy, or just busy. But my attempt to get
them to post their own patch didn't work

 drivers/edac/sb_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 993e8b61c4b2..63aa6730e89e 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -901,7 +901,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	else
 		edac_dbg(0, "Memory is unregistered\n");
 
-	if (mtype == MEM_DDR4 || MEM_RDDR4)
+	if (mtype == MEM_DDR4 || mtype == MEM_RDDR4)
 		banks = 16;
 	else
 		banks = 8;
-- 
2.1.0

