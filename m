Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab3DBCsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:48:31 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59010 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760001Ab3DBCqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:46:43 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v5 4/8] staging: zcache: fix pers_pageframes|_max aren't exported in debugfs
Date: Tue,  2 Apr 2013 10:46:16 +0800
Message-Id: <1364870780-16296-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364870780-16296-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1364870780-16296-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040202-5140-0000-0000-000002F8E81C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit 9c0ad59ef ("zcache/debug: Use an array to initialize/use debugfs attributes"),
pers_pageframes|_max are exported in debugfs, but this commit forgot use array export 
pers_pageframes|_max. This patch add pers_pageframes|_max back.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/debug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/debug.c b/drivers/staging/zcache/debug.c
index e951c64..254dada 100644
--- a/drivers/staging/zcache/debug.c
+++ b/drivers/staging/zcache/debug.c
@@ -21,6 +21,7 @@ static struct debug_entry {
 	ATTR(pers_ate_eph), ATTR(pers_ate_eph_failed),
 	ATTR(evicted_eph_zpages), ATTR(evicted_eph_pageframes),
 	ATTR(eph_pageframes), ATTR(eph_pageframes_max),
+	ATTR(pers_pageframes), ATTR(pers_pageframes_max),
 	ATTR(eph_zpages), ATTR(eph_zpages_max),
 	ATTR(pers_zpages), ATTR(pers_zpages_max),
 	ATTR(last_active_file_pageframes),
-- 
1.7.7.6

