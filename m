Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaIUQ3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:29:34 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44304 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaIUQ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:27:51 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com, Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 8/8] Revert "percpu: free percpu allocation info for uniprocessor system"
Date: Sun, 21 Sep 2014 09:27:18 -0700
Message-Id: <1411316838-15135-9-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3189eddbcafcc4d827f7f19facbeddec4424eba8.

The commit causes a hang with a crisv32 image. This may be an architecture
problem, but at least for now the revert is necessary to be able to boot a
crisv32 image.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 mm/percpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index da997f9..2139e30 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1932,8 +1932,6 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
-
-	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */
-- 
1.9.1

