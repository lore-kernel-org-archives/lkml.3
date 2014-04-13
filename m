Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaDMUJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 16:09:23 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:16188 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbaDMUJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 16:09:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisNADDuSlNXQ5wQ/2dsb2JhbABYgwaCS4EYwFcEAoEbF3SCUxMcIxiBAiQTiAABqH+hao4KZIQ/AQOOX4oBAYpkh1+DMzuBLA
Date: Sun, 13 Apr 2014 22:09:17 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: hch <hch@infradead.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/xfs/xfs_log.c: Fix comparison to bool
Message-Id: <20140413220917.a566d048eb0cc55b5ec9f7be@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing coccinelle warning

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org> 
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8497a00..efb8f92 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2376,7 +2376,7 @@ next_lv:
 				if (lv)
 					vecp = lv->lv_iovecp;
 			}
-			if (record_cnt == 0 && ordered == false) {
+			if (record_cnt == 0 && !ordered) {
 				if (!lv)
 					return 0;
 				break;
-- 
1.8.3.2

