Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaKXODF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:03:05 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48473 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaKXODE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:03:04 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH] mm/zsmalloc: remove uninitialized_var
Date: Mon, 24 Nov 2014 22:02:47 +0800
Message-Id: <1416837767-6868-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uninitialized_var() is not recommended to be used  to
avoid compiler warnings
  https://lkml.org/lkml/2012/10/27/71

So this patch initializes ret with *NOTIFY_OK*.

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index bb55736..480fa4c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -897,7 +897,7 @@ static void zs_unregister_cpu_notifier(void)
 
 static int zs_register_cpu_notifier(void)
 {
-	int cpu, uninitialized_var(ret);
+	int cpu, ret = NOTIFY_OK;
 
 	cpu_notifier_register_begin();
 
-- 
1.7.9.5

