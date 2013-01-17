Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3AQSWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:22:18 -0500
Received: from mail.prodrive.nl ([212.61.153.67]:44997 "EHLO mail.prodrive.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab3AQSWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:22:17 -0500
From: Stef van Os <stef.van.os@prodrive.nl>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <wfp5p@virginia.edu>, <gregkh@linuxfoundation.org>, <sr@denx.de>,
        <plagnioj@jcrosoft.com>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Stef van Os <stef.van.os@prodrive.nl>
Subject: [PATCH 1/1] mtd: physmap_of: fix illegal dereference
Date: Thu, 17 Jan 2013 19:22:12 +0100
Message-ID: <1358446932-7238-1-git-send-email-stef.van.os@prodrive.nl>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-TM-AS-Product-Ver: IMSVA-8.2.0.1520-7.0.0.1014-19564.001
X-TM-AS-Result: No--17.319-5.0-31-10
X-imss-scan-details: No--17.319-5.0-31-10
X-TM-AS-User-Approved-Sender: No
X-TMASE-Version: IMSVA-8.2.0.1520-7.0.1014-19564.001
X-TMASE-Result: 10--17.319300-5.000000
X-TMASE-MatchedRID: d+baqQ3qUqdaDdlHsEs+7ULhYg/sa1gs5Y0kb0hqaty3LDb3luvXBKRG
	wX+NnBzgv+io1+NFyY0BtjkcfRMmqdjMn8qi5/yFFYJUGv4DL3yH7D1bP/FcOmxZRBWPMUZWlR1
	cT9YafQW1M9j+NBdIc+TCMddcL/gjkGUtrowrXLg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d68cbdd introduced a new way of getting the name of an mtd
partion. The character pointer is not initialized, and only
checked against NULL, not at other random garbage.
This patch fixes the resulting panic.

Signed-off-by: Stef van Os <stef.van.os@prodrive.nl>
---
 drivers/mtd/maps/physmap_of.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 67cc73c..7901d72 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -170,7 +170,7 @@ static int of_flash_probe(struct platform_device *dev)
 	resource_size_t res_size;
 	struct mtd_part_parser_data ppdata;
 	bool map_indirect;
-	const char *mtd_name;
+	const char *mtd_name = NULL;
 
 	match = of_match_device(of_flash_match, &dev->dev);
 	if (!match)
-- 
1.7.2.5

