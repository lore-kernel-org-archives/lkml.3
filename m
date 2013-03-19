Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116Ab3CSJ0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:26:45 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52939 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3CSJ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:26:41 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 5/8] staging: zcache: fix zcache writeback in debugfs
Date: Tue, 19 Mar 2013 17:25:47 +0800
Message-Id: <1363685150-18303-6-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031909-7014-0000-0000-000002BBE464
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9c0ad59ef ("zcache/debug: Use an array to initialize/use debugfs attributes") 
use an array to initialize/use debugfs attributes, .name = #x, .val = &zcache_##x.
For zcache writeback, this commit set .name = zcache_outstanding_writeback_pages and 
.name = zcache_writtenback_pages seperately, however, corresponding .val = 
&zcache_zcache_outstanding_writeback_pages and .val = &zcache_zcache_writtenback_pages,
which are not correct.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/debug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/debug.c b/drivers/staging/zcache/debug.c
index 254dada..d2d1fdf 100644
--- a/drivers/staging/zcache/debug.c
+++ b/drivers/staging/zcache/debug.c
@@ -31,8 +31,8 @@ static struct debug_entry {
 	ATTR(eph_nonactive_puts_ignored),
 	ATTR(pers_nonactive_puts_ignored),
 #ifdef CONFIG_ZCACHE_WRITEBACK
-	ATTR(zcache_outstanding_writeback_pages),
-	ATTR(zcache_writtenback_pages),
+	ATTR(outstanding_writeback_pages),
+	ATTR(writtenback_pages),
 #endif
 };
 #undef ATTR
-- 
1.7.7.6

