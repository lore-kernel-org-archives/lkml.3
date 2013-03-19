Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab3CSJ1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:27:36 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37829 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004Ab3CSJ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:26:43 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 4/8] staging: zcache: fix pers_pageframes|_max aren't exported in debugfs
Date: Tue, 19 Mar 2013 17:25:46 +0800
Message-Id: <1363685150-18303-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 13031909-5140-0000-0000-000002E963BD
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

