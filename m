Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3H2XJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:09:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58444 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752904Ab3H2XJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:09:36 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] timer: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)
Date: Thu, 29 Aug 2013 16:09:33 -0700
Message-Id: <151f9b2c9f3592af481fcb4e1b4cfb0c9eeb93d2.1377817718.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the helper function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/timer.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 4296d13..fab8eac 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1518,9 +1518,8 @@ static int init_timers_cpu(int cpu)
 			/*
 			 * The APs use this path later in boot
 			 */
-			base = kmalloc_node(sizeof(*base),
-						GFP_KERNEL | __GFP_ZERO,
-						cpu_to_node(cpu));
+			base = kzalloc_node(sizeof(*base), GFP_KERNEL,
+					    cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

