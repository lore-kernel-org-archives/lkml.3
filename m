Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3FEHSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:18:13 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36895 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3FEHSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:18:12 -0400
Message-ID: <51AEE53C.5050704@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 15:14:04 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/3] workqueue: code refine in wqattrs_equal()
References: <51AEE452.8080605@linux.vnet.ibm.com>
In-Reply-To: <51AEE452.8080605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060507-1396-0000-0000-00000311A2E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

code refine to save some line.

CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/workqueue.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ee8e29a..5fd4791 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3417,9 +3417,8 @@ static bool wqattrs_equal(const struct workqueue_attrs *a,
 {
 	if (a->nice != b->nice)
 		return false;
-	if (!cpumask_equal(a->cpumask, b->cpumask))
-		return false;
-	return true;
+
+	return cpumask_equal(a->cpumask, b->cpumask);
 }
 
 /**
-- 
1.7.4.1

