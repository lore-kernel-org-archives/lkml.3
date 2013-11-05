Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3KENqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:46:10 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:41465 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3KENqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:46:08 -0500
Subject: [PATCH 3/3] makedumpfile: hugepage filtering: add new dump levels
 for manual page
To: ptesarik@suse.cz, d.hatayama@jp.fujitsu.com,
        kumagai-atsushi@mxc.nes.nec.co.jp
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: bhe@redhat.com, tom.vaden@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        anderson@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com
Date: Tue, 05 Nov 2013 21:46:03 +0800
Message-ID: <20131105134603.32112.63599.stgit@k.asiapacific.hpqcorp.net>
In-Reply-To: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new dump levels for makedumpfile manual page.

Signed-off-by: Jingbai Ma <jingbai.ma@hp.com>
---
 makedumpfile.8 |  170 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 133 insertions(+), 37 deletions(-)

diff --git a/makedumpfile.8 b/makedumpfile.8
index adeb811..70e8732 100644
--- a/makedumpfile.8
+++ b/makedumpfile.8
@@ -164,43 +164,139 @@ by dump_level 11, makedumpfile retries it by dump_level 31.
 .br
 # makedumpfile \-d 11,31 \-x vmlinux /proc/vmcore dumpfile
 
-       |      |cache  |cache  |      |
-  dump | zero |without|with   | user | free
- level | page |private|private| data | page
-.br
-\-\-\-\-\-\-\-+\-\-\-\-\-\-+\-\-\-\-\-\-\-+\-\-\-\-\-\-\-+\-\-\-\-\-\-+\-\-\-\-\-\-
-     0 |      |       |       |      |
-     1 |  X   |       |       |      |
-     2 |      |   X   |       |      |
-     3 |  X   |   X   |       |      |
-     4 |      |   X   |   X   |      |
-     5 |  X   |   X   |   X   |      |
-     6 |      |   X   |   X   |      |
-     7 |  X   |   X   |   X   |      |
-     8 |      |       |       |  X   |
-     9 |  X   |       |       |  X   |
-    10 |      |   X   |       |  X   |
-    11 |  X   |   X   |       |  X   |
-    12 |      |   X   |   X   |  X   |
-    13 |  X   |   X   |   X   |  X   |
-    14 |      |   X   |   X   |  X   |
-    15 |  X   |   X   |   X   |  X   |
-    16 |      |       |       |      |  X
-    17 |  X   |       |       |      |  X
-    18 |      |   X   |       |      |  X
-    19 |  X   |   X   |       |      |  X
-    20 |      |   X   |   X   |      |  X
-    21 |  X   |   X   |   X   |      |  X
-    22 |      |   X   |   X   |      |  X
-    23 |  X   |   X   |   X   |      |  X
-    24 |      |       |       |  X   |  X
-    25 |  X   |       |       |  X   |  X
-    26 |      |   X   |       |  X   |  X
-    27 |  X   |   X   |       |  X   |  X
-    28 |      |   X   |   X   |  X   |  X
-    29 |  X   |   X   |   X   |  X   |  X
-    30 |      |   X   |   X   |  X   |  X
-    31 |  X   |   X   |   X   |  X   |  X
+       |      |cache  |cache  |      |      | free | active
+  dump | zero |without|with   | user | free | huge | huge
+ level | page |private|private| data | page | page | page
+.br
+\-\-\-\-\-\-\-+\-\-\-\-\-\-+\-\-\-\-\-\-\-+\-\-\-\-\-\-\-+\-\-\-\-\-\-+\-\-\-\-\-\-+\-\-\-\-\-\-+\-\-\-\-\-\-\-\-
+     0 |      |       |       |      |      |      |
+     1 |  X   |       |       |      |      |      |
+     2 |      |   X   |       |      |      |      |
+     3 |  X   |   X   |       |      |      |      |
+     4 |      |   X   |   X   |      |      |      |
+     5 |  X   |   X   |   X   |      |      |      |
+     6 |      |   X   |   X   |      |      |      |
+     7 |  X   |   X   |   X   |      |      |      |
+     8 |      |       |       |  X   |      |      |
+     9 |  X   |       |       |  X   |      |      |
+    10 |      |   X   |       |  X   |      |      |
+    11 |  X   |   X   |       |  X   |      |      |
+    12 |      |   X   |   X   |  X   |      |      |
+    13 |  X   |   X   |   X   |  X   |      |      |
+    14 |      |   X   |   X   |  X   |      |      |
+    15 |  X   |   X   |   X   |  X   |      |      |
+    16 |      |       |       |      |  X   |      |
+    17 |  X   |       |       |      |  X   |      |
+    18 |      |   X   |       |      |  X   |      |
+    19 |  X   |   X   |       |      |  X   |      |
+    20 |      |   X   |   X   |      |  X   |      |
+    21 |  X   |   X   |   X   |      |  X   |      |
+    22 |      |   X   |   X   |      |  X   |      |
+    23 |  X   |   X   |   X   |      |  X   |      |
+    24 |      |       |       |  X   |  X   |      |
+    25 |  X   |       |       |  X   |  X   |      |
+    26 |      |   X   |       |  X   |  X   |      |
+    27 |  X   |   X   |       |  X   |  X   |      |
+    28 |      |   X   |   X   |  X   |  X   |      |
+    29 |  X   |   X   |   X   |  X   |  X   |      |
+    30 |      |   X   |   X   |  X   |  X   |      |
+    31 |  X   |   X   |   X   |  X   |  X   |      |
+    32 |      |       |       |      |      |  X   |
+    33 |  X   |       |       |      |      |  X   |
+    34 |      |   X   |       |      |      |  X   |
+    35 |  X   |   X   |       |      |      |  X   |
+    36 |      |   X   |   X   |      |      |  X   |
+    37 |  X   |   X   |   X   |      |      |  X   |
+    38 |      |   X   |   X   |      |      |  X   |
+    39 |  X   |   X   |   X   |      |      |  X   |
+    40 |      |       |       |  X   |      |  X   |
+    41 |  X   |       |       |  X   |      |  X   |
+    42 |      |   X   |       |  X   |      |  X   |
+    43 |  X   |   X   |       |  X   |      |  X   |
+    44 |      |   X   |   X   |  X   |      |  X   |
+    45 |  X   |   X   |   X   |  X   |      |  X   |
+    46 |      |   X   |   X   |  X   |      |  X   |
+    47 |  X   |   X   |   X   |  X   |      |  X   |
+    48 |      |       |       |      |  X   |  X   |
+    49 |  X   |       |       |      |  X   |  X   |
+    50 |      |   X   |       |      |  X   |  X   |
+    51 |  X   |   X   |       |      |  X   |  X   |
+    52 |      |   X   |   X   |      |  X   |  X   |
+    53 |  X   |   X   |   X   |      |  X   |  X   |
+    54 |      |   X   |   X   |      |  X   |  X   |
+    55 |  X   |   X   |   X   |      |  X   |  X   |
+    56 |      |       |       |  X   |  X   |  X   |
+    57 |  X   |       |       |  X   |  X   |  X   |
+    58 |      |   X   |       |  X   |  X   |  X   |
+    59 |  X   |   X   |       |  X   |  X   |  X   |
+    60 |      |   X   |   X   |  X   |  X   |  X   |
+    61 |  X   |   X   |   X   |  X   |  X   |  X   |
+    62 |      |   X   |   X   |  X   |  X   |  X   |
+    63 |  X   |   X   |   X   |  X   |  X   |  X   |
+    64 |      |       |       |      |      |  X   |  X
+    65 |  X   |       |       |      |      |  X   |  X
+    66 |      |   X   |       |      |      |  X   |  X
+    67 |  X   |   X   |       |      |      |  X   |  X
+    68 |      |   X   |   X   |      |      |  X   |  X
+    69 |  X   |   X   |   X   |      |      |  X   |  X
+    70 |      |   X   |   X   |      |      |  X   |  X
+    71 |  X   |   X   |   X   |      |      |  X   |  X
+    72 |      |       |       |  X   |      |  X   |  X
+    73 |  X   |       |       |  X   |      |  X   |  X
+    74 |      |   X   |       |  X   |      |  X   |  X
+    75 |  X   |   X   |       |  X   |      |  X   |  X
+    76 |      |   X   |   X   |  X   |      |  X   |  X
+    77 |  X   |   X   |   X   |  X   |      |  X   |  X
+    78 |      |   X   |   X   |  X   |      |  X   |  X
+    79 |  X   |   X   |   X   |  X   |      |  X   |  X
+    80 |      |       |       |      |  X   |  X   |  X
+    81 |  X   |       |       |      |  X   |  X   |  X
+    82 |      |   X   |       |      |  X   |  X   |  X
+    83 |  X   |   X   |       |      |  X   |  X   |  X
+    84 |      |   X   |   X   |      |  X   |  X   |  X
+    85 |  X   |   X   |   X   |      |  X   |  X   |  X
+    86 |      |   X   |   X   |      |  X   |  X   |  X
+    87 |  X   |   X   |   X   |      |  X   |  X   |  X
+    88 |      |       |       |  X   |  X   |  X   |  X
+    89 |  X   |       |       |  X   |  X   |  X   |  X
+    90 |      |   X   |       |  X   |  X   |  X   |  X
+    91 |  X   |   X   |       |  X   |  X   |  X   |  X
+    92 |      |   X   |   X   |  X   |  X   |  X   |  X
+    93 |  X   |   X   |   X   |  X   |  X   |  X   |  X
+    94 |      |   X   |   X   |  X   |  X   |  X   |  X
+    95 |  X   |   X   |   X   |  X   |  X   |  X   |  X
+    96 |      |       |       |      |      |  X   |  X
+    97 |  X   |       |       |      |      |  X   |  X
+    98 |      |   X   |       |      |      |  X   |  X
+    99 |  X   |   X   |       |      |      |  X   |  X
+   100 |      |   X   |   X   |      |      |  X   |  X
+   101 |  X   |   X   |   X   |      |      |  X   |  X
+   102 |      |   X   |   X   |      |      |  X   |  X
+   103 |  X   |   X   |   X   |      |      |  X   |  X
+   104 |      |       |       |  X   |      |  X   |  X
+   105 |  X   |       |       |  X   |      |  X   |  X
+   106 |      |   X   |       |  X   |      |  X   |  X
+   107 |  X   |   X   |       |  X   |      |  X   |  X
+   108 |      |   X   |   X   |  X   |      |  X   |  X
+   109 |  X   |   X   |   X   |  X   |      |  X   |  X
+   110 |      |   X   |   X   |  X   |      |  X   |  X
+   111 |  X   |   X   |   X   |  X   |      |  X   |  X
+   112 |      |       |       |      |  X   |  X   |  X
+   113 |  X   |       |       |      |  X   |  X   |  X
+   114 |      |   X   |       |      |  X   |  X   |  X
+   115 |  X   |   X   |       |      |  X   |  X   |  X
+   116 |      |   X   |   X   |      |  X   |  X   |  X
+   117 |  X   |   X   |   X   |      |  X   |  X   |  X
+   118 |      |   X   |   X   |      |  X   |  X   |  X
+   119 |  X   |   X   |   X   |      |  X   |  X   |  X
+   120 |      |       |       |  X   |  X   |  X   |  X
+   121 |  X   |       |       |  X   |  X   |  X   |  X
+   122 |      |   X   |       |  X   |  X   |  X   |  X
+   123 |  X   |   X   |       |  X   |  X   |  X   |  X
+   124 |      |   X   |   X   |  X   |  X   |  X   |  X
+   125 |  X   |   X   |   X   |  X   |  X   |  X   |  X
+   126 |      |   X   |   X   |  X   |  X   |  X   |  X
+   127 |  X   |   X   |   X   |  X   |  X   |  X   |  X
 
 
 .TP

