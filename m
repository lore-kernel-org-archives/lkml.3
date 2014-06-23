Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbaFWQfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:35:09 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:47675 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755742AbaFWQfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:35:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHABBWqFNbskjJ/2dsb2JhbABZgw2rZQUBAQEBAQEFAZk1gQ8XdYQxLyOBGjeIRgHEIheFY4kZHYQtBJpMk2ODRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-omap@vger.kernel.org
Subject: [PATCH 1/1] sound/soc/omap/mcbsp.c: remove unnecessary null test before kfree
Date: Mon, 23 Jun 2014 18:33:41 +0200
Message-Id: <1403541221-10619-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 sound/soc/omap/mcbsp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/omap/mcbsp.c b/sound/soc/omap/mcbsp.c
index 86c7538..68a1252 100644
--- a/sound/soc/omap/mcbsp.c
+++ b/sound/soc/omap/mcbsp.c
@@ -621,8 +621,7 @@ void omap_mcbsp_free(struct omap_mcbsp *mcbsp)
 	mcbsp->reg_cache = NULL;
 	spin_unlock(&mcbsp->lock);
 
-	if (reg_cache)
-		kfree(reg_cache);
+	kfree(reg_cache);
 }
 
 /*
-- 
1.8.4.5

