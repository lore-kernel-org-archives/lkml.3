Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3GYMOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:14:46 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:37895 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3GYMOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:14:44 -0400
From: Tom Rini <trini@ti.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Jianpeng Ma <majianpeng@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <greg@kroah.com>
Subject: [PATCH] numa: Mark __node_set as __always_inline
Date: Thu, 25 Jul 2013 08:14:49 -0400
Message-Id: <1374754489-4559-1-git-send-email-trini@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is posible for some compilers to decide that __node_set does not need
to be made turned into an inline function.  When the compiler does this
on an __init function calling it on __initdata we get a section mismatch
warning now.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Jianpeng Ma <majianpeng@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Tom Rini <trini@ti.com>
---
 include/linux/nodemask.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 4e2cbfa..10d0fd9 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -99,7 +99,7 @@ typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
 extern nodemask_t _unused_nodemask_arg_;
 
 #define node_set(node, dst) __node_set((node), &(dst))
-static inline void __node_set(int node, volatile nodemask_t *dstp)
+static __always_inline void __node_set(int node, volatile nodemask_t *dstp)
 {
 	set_bit(node, dstp->bits);
 }
-- 
1.7.9.5

