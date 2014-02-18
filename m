Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaBRCky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:40:54 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:17656 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaBRCkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:40:42 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: linux-kernel@vger.kernel.org, davidlohr@hp.com
Subject: [PATCH 2/2] ipc: use device_initcall
Date: Mon, 17 Feb 2014 18:40:30 -0800
Message-Id: <1392691230-16394-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392691230-16394-1-git-send-email-davidlohr@hp.com>
References: <1392691230-16394-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... since __initcall is now deprecated.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/ipc_sysctl.c | 2 +-
 ipc/mqueue.c     | 2 +-
 ipc/util.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 1702864..998d31b 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -281,4 +281,4 @@ static int __init ipc_sysctl_init(void)
 	return 0;
 }
 
-__initcall(ipc_sysctl_init);
+device_initcall(ipc_sysctl_init);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c3b3117..4fcf39a 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1459,4 +1459,4 @@ out_sysctl:
 	return error;
 }
 
-__initcall(init_mqueue_fs);
+device_initcall(init_mqueue_fs);
diff --git a/ipc/util.c b/ipc/util.c
index e1b4c6d..2eb0d1e 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -128,7 +128,7 @@ static int __init ipc_init(void)
 	register_ipcns_notifier(&init_ipc_ns);
 	return 0;
 }
-__initcall(ipc_init);
+device_initcall(ipc_init);
 
 /**
  * ipc_init_ids	- initialise ipc identifiers
-- 
1.8.1.4

