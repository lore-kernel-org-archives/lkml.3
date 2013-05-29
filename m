Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966373Ab3E2OpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:45:20 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35402 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966095Ab3E2OpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:45:17 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH, v2 01/13] mm: introduce helper function set_max_mapnr()
Date: Wed, 29 May 2013 22:44:40 +0800
Message-Id: <1369838692-26860-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
References: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce an helper function set_max_mapnr() to set global variable
max_mapnr.

Also unify condition compilation for max_mapnr with
CONFIG_NEED_MULTIPLE_NODES instead of CONFIG_DISCONTIGMEM.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/mm.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7e39aa1..bde812e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -25,8 +25,15 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 
-#ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
+#ifndef CONFIG_NEED_MULTIPLE_NODES	/* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
+
+static inline void set_max_mapnr(unsigned long limit)
+{
+	max_mapnr = limit;
+}
+#else
+static inline void set_max_mapnr(unsigned long limit) { }
 #endif
 
 extern unsigned long totalram_pages;
-- 
1.8.1.2

