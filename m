Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbaGYSa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:30:58 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:43856 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaGYSaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:30:55 -0400
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: m.chehab@samsung.com, hans.verkuil@cisco.com, khalasa@piap.pl,
        ismael.luceno@corp.bluecherry.net
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH] drivers/media/pci/solo6x10/solo6x10-disp.c: check kzalloc() result
Date: Fri, 25 Jul 2014 21:30:49 +0300
Message-Id: <1406313049-9604-1-git-send-email-andrey.utkin@corp.bluecherry.net>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 drivers/media/pci/solo6x10/solo6x10-disp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10-disp.c b/drivers/media/pci/solo6x10/solo6x10-disp.c
index ed88ab4..93cbbb1 100644
--- a/drivers/media/pci/solo6x10/solo6x10-disp.c
+++ b/drivers/media/pci/solo6x10/solo6x10-disp.c
@@ -216,6 +216,8 @@ int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch,
 	int ret = 0;
 
 	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 	for (y = 0; y < SOLO_MOTION_SZ; y++) {
 		for (x = 0; x < SOLO_MOTION_SZ; x++)
 			buf[x] = cpu_to_le16(thresholds[y * SOLO_MOTION_SZ + x]);
-- 
1.8.5.5

