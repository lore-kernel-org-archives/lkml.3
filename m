Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaBMCDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:03:08 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51288 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaBMCDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:03:07 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: akpm@linux-foundation.org
Cc: toshi.kani@hp.com, isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com,
        gong.chen@linux.intel.com, haokexin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/resource.c: fix sparse non static symbol warning
Date: Thu, 13 Feb 2014 11:02:59 +0900
Message-ID: <2767883.6dX08SOjIi@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f8e0752ac80e56bcbfe197a5820692d199822b52 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Thu, 13 Feb 2014 10:11:39 +0900
Subject: [PATCH] kernel/resource.c: fix sparse non static symbol warning

kernel/resource.c:518:5: warning:
 symbol 'reallocate_resource' was not declared. Should it be static?

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 3f285dc..b2979c6 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -515,7 +515,7 @@ static int find_resource(struct resource *root, struct resource *new,
  * @newsize: new size of the resource descriptor
  * @constraint: the size and alignment constraints to be met.
  */
-int reallocate_resource(struct resource *root, struct resource *old,
+static int reallocate_resource(struct resource *root, struct resource *old,
 			resource_size_t newsize,
 			struct resource_constraint  *constraint)
 {
-- 
1.7.9.5


