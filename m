Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3FGMI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:08:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19373 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3FGMIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:08:54 -0400
Date: Fri, 7 Jun 2013 15:07:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -mm] mm, vmalloc: unbreak __vunmap()
Message-ID: <20130607120738.GA13851@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an extra semi-colon so the function always returns.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 91a1047..96b77a9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1453,7 +1453,7 @@ static void __vunmap(const void *addr, int deallocate_pages)
 		return;
 
 	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
-			addr));
+			addr))
 		return;
 
 	area = remove_vm_area(addr);
