Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaEXNHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 09:07:43 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:4522 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaEXNHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 09:07:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEJAKOYgFNbtALU/2dsb2JhbABagwerGAUBgzyUToEEF3SDAiOBGjeIRgHYBoVViH0dhCoEjz+KNIsXiBCDOjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] lib/debugobjects.c: move __initdata after name
Date: Sat, 24 May 2014 15:07:19 +0200
Message-Id: <1400936839-25007-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/debugobjects.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index b628247..437a6b4 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -791,7 +791,7 @@ struct self_test {
 	unsigned long	dummy2[3];
 };
 
-static __initdata struct debug_obj_descr descr_type_test;
+static struct debug_obj_descr descr_type_test __initdata;
 
 /*
  * fixup_init is called when:
@@ -915,7 +915,7 @@ out:
 	return res;
 }
 
-static __initdata struct debug_obj_descr descr_type_test = {
+static struct debug_obj_descr descr_type_test __initdata = {
 	.name			= "selftest",
 	.fixup_init		= fixup_init,
 	.fixup_activate		= fixup_activate,
@@ -923,7 +923,7 @@ static __initdata struct debug_obj_descr descr_type_test = {
 	.fixup_free		= fixup_free,
 };
 
-static __initdata struct self_test obj = { .static_init = 0 };
+static struct self_test obj __initdata = { .static_init = 0 };
 
 static void __init debug_objects_selftest(void)
 {
-- 
1.8.4.5

