Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3ARVYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:24:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42293 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3ARVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:24:39 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, ngupta@vflare.org,
        konrad.wilk@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, dan.magenheimer@oracle.com
Subject: [PATCH 5/5] staging: zcache: fix uninitialized variable compile warning
Date: Fri, 18 Jan 2013 13:24:27 -0800
Message-Id: <1358544267-9104-6-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
References: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[V2: no code changes, patchset now generated via git format-patch -M]

Fix unitialized variable in zcache which generates warning during build

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index a09dd5c..6ab13e1 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1346,7 +1346,7 @@ static int zcache_local_new_pool(uint32_t flags)
 int zcache_autocreate_pool(unsigned int cli_id, unsigned int pool_id, bool eph)
 {
 	struct tmem_pool *pool;
-	struct zcache_client *cli;
+	struct zcache_client *cli = NULL;
 	uint32_t flags = eph ? 0 : TMEM_POOL_PERSIST;
 	int ret = -1;
 
-- 
1.7.1

