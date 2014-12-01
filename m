Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaLALGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:06:34 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:35218 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753270AbaLALGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:06:21 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44259001"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: [PATCH v9 3/3] Documentation: add docs for /proc/pidns_hierarchy
Date: Mon, 1 Dec 2014 19:06:18 +0800
Message-ID: <1417431978-24723-4-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417431978-24723-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1417431978-24723-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 Documentation/namespaces/pidns-hierarchy.txt | 51 ++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/namespaces/pidns-hierarchy.txt

diff --git a/Documentation/namespaces/pidns-hierarchy.txt b/Documentation/namespaces/pidns-hierarchy.txt
new file mode 100644
index 0000000..1820ae6d
--- /dev/null
+++ b/Documentation/namespaces/pidns-hierarchy.txt
@@ -0,0 +1,51 @@
+This document is about how to use pid namespace hierarchy procfs.
+
+We knew whether two pids living in the same pid namespace
+by /proc/PID/ns/pid, but their relationships
+between pids were unknown:
+we couldn't tell that one pid was another one's parent/siblings...
+But /proc/pidns_hierarchy could tell us the answer.
+
+/proc/pidns_hierarchy will show the hierarchy of pid namespace
+in the form of:
+
+<init_PID> <parent_of_init_PID> <relative PID level>
+
+init_PID:            child reaper in a pid namespace
+parent_of_init_PID:  init_PID's parent, child reaper too
+relative PID level:  pid level relative to caller's ns,
+                     started from '1'.
+
+Here is a chart to describe the relationship between
+some pids:
+
+         init_pid_ns                          level 0
+              |
+              1
+              |
+┌────────────┐
+ns1                      ns2                  level 1
+|                         |
+1550                    18060
+                          |
+                          |
+                         ns3                  level 2
+                          |
+                        18102
+                          |
+                 ┌──────────┐
+                 ns4                   ns5    level 3
+                 |                     |
+                1534                  1600
+
+It will be showed by /proc/pidns_hierarchy as below:
+
+#cat /proc/pidns_hierarchy
+18060 1 1
+18102 18060 2
+1534  18102 3
+1600  18102 3
+1550  1 1
+
+Note: numbers in column 1 are pid numbers in current ns,
+    they represent the pid '1' in different ns
-- 
1.9.3

