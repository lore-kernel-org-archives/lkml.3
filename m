Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbaKMNiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:38:08 -0500
Received: from mail-pd0-f194.google.com ([209.85.192.194]:55932 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbaKMNiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:38:06 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org, ddstreet@ieee.org,
        sergey.senozhatsky@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH 2/3] mm/zsmalloc: add __init/__exit to zs_init/zs_exit
Date: Thu, 13 Nov 2014 21:37:36 +0800
Message-Id: <1415885857-5283-2-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415885857-5283-1-git-send-email-opensource.ganesh@gmail.com>
References: <1415885857-5283-1-git-send-email-opensource.ganesh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After patch [1], the zs_exit is only called in module exit.
So add __init/__exit to zs_init/zs_exit.

  [1] mm/zsmalloc: avoid unregister a NOT-registered zsmalloc zpool driver

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 3d2bb36..92af030 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -881,7 +881,7 @@ static struct notifier_block zs_cpu_nb = {
 	.notifier_call = zs_cpu_notifier
 };
 
-static void zs_exit(void)
+static void __exit zs_exit(void)
 {
 	int cpu;
 
@@ -898,7 +898,7 @@ static void zs_exit(void)
 	cpu_notifier_register_done();
 }
 
-static int zs_init(void)
+static int __init zs_init(void)
 {
 	int cpu, ret;
 
-- 
1.7.9.5

