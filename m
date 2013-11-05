Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3KEKIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 05:08:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20500 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3KEKIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 05:08:12 -0500
X-IronPort-AV: E=Sophos;i="4.93,638,1378828800"; 
   d="scan'208";a="8951791"
Message-ID: <5278C21B.7010204@cn.fujitsu.com>
Date: Tue, 05 Nov 2013 18:02:03 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH] fs/buffer.c: exit if already confirmed page has dirty
 and writeback buffers
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/05 18:06:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/05 18:06:19,
	Serialize complete at 2013/11/05 18:06:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the loop of iterating bh if we have confirmed page
has dirty and writeback buffers.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6024877..519cc5c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -112,7 +112,7 @@ void buffer_check_dirty_writeback(struct page *page,
 			*dirty = true;
 
 		bh = bh->b_this_page;
-	} while (bh != head);
+	} while ((bh != head) && !(*writeback && *dirty));
 }
 EXPORT_SYMBOL(buffer_check_dirty_writeback);
 
-- 
1.7.7

