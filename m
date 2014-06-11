Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaFKSsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:48:24 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:42679 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbaFKSsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:48:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugHAH2jmFNbslCP/2dsb2JhbABagw2rdAUBAQEBAQEFAZkbgQgXdYRgI4EaN4hGAdAqhVyIGWQdhCsEmi6TS4F8gUI7gTA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 1/1] drivers/misc/sgi-gru/grukdump.c: remove unnecessary test on unsigned int
Date: Wed, 11 Jun 2014 20:47:02 +0200
Message-Id: <1402512422-15990-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned value is never < 0

Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/misc/sgi-gru/grukdump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-gru/grukdump.c b/drivers/misc/sgi-gru/grukdump.c
index a3700a5..e0e0e7e 100644
--- a/drivers/misc/sgi-gru/grukdump.c
+++ b/drivers/misc/sgi-gru/grukdump.c
@@ -196,7 +196,7 @@ int gru_dump_chiplet_request(unsigned long arg)
 		return -EFAULT;
 
 	/* Currently, only dump by gid is implemented */
-	if (req.gid >= gru_max_gids || req.gid < 0)
+	if (req.gid >= gru_max_gids)
 		return -EINVAL;
 
 	gru = GID_TO_GRU(req.gid);
-- 
1.8.4.5

