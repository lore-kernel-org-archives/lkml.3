Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbaLBEEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:04:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34554 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888AbaLBEE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:04:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Subject: [PATCH] mm: fadvise: avoid signed integer overflow calculating offset
Date: Mon,  1 Dec 2014 23:04:08 -0500
Message-Id: <1417493050-13594-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
References: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both offset and len are signed integers who's overflow isn't defined. Use
unsigned addition to avoid the issue.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/fadvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 3bcfd81d..762cb63 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -67,7 +67,7 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 	}
 
 	/* Careful about overflows. Len == 0 means "as much as possible" */
-	endbyte = offset + len;
+	endbyte = offset + (u64)len;
 	if (!len || endbyte < len)
 		endbyte = -1;
 	else
-- 
1.7.10.4

