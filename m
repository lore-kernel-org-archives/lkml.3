Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3DLBbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:31:51 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:44697 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3DLBbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:31:41 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH PART2 v2 1/7] staging: ramster: decrease foregin pers pages when count < 0
Date: Fri, 12 Apr 2013 09:31:21 +0800
Message-Id: <1365730287-16876-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365730287-16876-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1365730287-16876-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-8256-0000-0000-0000070A3D9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9a5c59687ad ("staging: ramster: Provide accessory functions for 
counter decrease") forget decrease foregin pers pages, this patch fix 
it.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/ramster/ramster.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/zcache/ramster/ramster.c b/drivers/staging/zcache/ramster/ramster.c
index c3d7f96..444189e 100644
--- a/drivers/staging/zcache/ramster/ramster.c
+++ b/drivers/staging/zcache/ramster/ramster.c
@@ -508,6 +508,7 @@ void ramster_count_foreign_pages(bool eph, int count)
 		if (count > 0) {
 			inc_ramster_foreign_pers_pages();
 		} else {
+			dec_ramster_foreign_pers_pages();
 			WARN_ON_ONCE(ramster_foreign_pers_pages < 0);
 		}
 	}
-- 
1.7.10.4

