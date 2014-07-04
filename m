Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbaGDUHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:07:20 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:9047 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbaGDUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:07:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAMAFYIt1NbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BmWeBCxd1hGAjgRo3iEYBtVKVCxeFcIkyHYQtBZAJim2LTIhAg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org
Subject: [PATCH 1/1] arch/sh/mm/asids-debugfs.c: use PTR_ERR_OR_ZERO
Date: Fri,  4 Jul 2014 22:07:09 +0200
Message-Id: <1404504429-602-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 arch/sh/mm/asids-debugfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/sh/mm/asids-debugfs.c b/arch/sh/mm/asids-debugfs.c
index 74c03ec..ecfc6b0 100644
--- a/arch/sh/mm/asids-debugfs.c
+++ b/arch/sh/mm/asids-debugfs.c
@@ -67,10 +67,8 @@ static int __init asids_debugfs_init(void)
 					   NULL, &asids_debugfs_fops);
 	if (!asids_dentry)
 		return -ENOMEM;
-	if (IS_ERR(asids_dentry))
-		return PTR_ERR(asids_dentry);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(asids_dentry);
 }
 module_init(asids_debugfs_init);
 
-- 
1.9.1

