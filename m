Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3FMWmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:42:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26381 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419Ab3FMWmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:42:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [Patch v5 8/9] liblockdep: Add the 'lockdep' user-space utility
Date: Thu, 13 Jun 2013 18:41:23 -0400
Message-Id: <1371163284-6346-9-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a simple wrapper to make using liblockdep on existing
applications much easier.

After running 'make && make install', it becomes quite simple to
test things with liblockdep. For example, to try it on perf:

	lockdep perf

No other integration required.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/lockdep | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100755 tools/lib/lockdep/lockdep

diff --git a/tools/lib/lockdep/lockdep b/tools/lib/lockdep/lockdep
new file mode 100755
index 0000000..a805c81
--- /dev/null
+++ b/tools/lib/lockdep/lockdep
@@ -0,0 +1,3 @@
+#! /bin/bash
+
+LD_PRELOAD="liblockdep.so $LD_PRELOAD" "$@"
-- 
1.8.1.2

