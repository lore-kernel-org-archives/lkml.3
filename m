Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3GVIla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:41:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59552 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab3GVIlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:41:25 -0400
X-AuditID: cbfee68f-b7f436d000000f81-f6-51ecf0342d7f
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] Documentation: replace strict_strtoul() with kstrtoul()
Date: Mon, 22 Jul 2013 17:41:23 +0900
Message-id: <000501ce86b7$3f4ab1c0$bde01540$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6GtxC0Jj3oiXmjRL+FP4XdDdzrRQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zI12TD28CDRY/5baYs34Nm8XlhZdY
	LRa2LWGxuLxrDpvFupfTWRxYPV6tnsnqcWLGbxaPvi2rGD0+b5ILYInisklJzcksSy3St0vg
	yjj5YQpjwUn+im+XPrI1MF7j6WLk5JAQMJE4t+41E4QtJnHh3no2EFtIYBmjROc+aZiapz2z
	2bsYuYDi0xkldp7+COX8YpQ403kYrJtNQE3iy5fD7CC2iICuxKrnu5hBbGaBOomWN0dZQGxh
	AQ+JB8vmMILYLAKqEmf674H18gpYSjz6tgzKFpT4MfkeC0SvlsT6nceZIGx5ic1r3jJDXKQg
	sePsa6A5HEC79CRuLreCKBGR2PfiHSPIbRICu9gl+r78ZIXYJSDxbfIhFpB6CQFZiU0HoMZI
	ShxccYNlAqPYLCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERJv
	/TsY7x6wPsSYDLR+IrOUaHI+MF7zSuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cA4beHW5BPPLyWL8FrO7UyOvmf2oPvg7KAQ7+VcR292vUiLY/dX
	q9HSOxpzvtFK02x/z8Rp8QeYePN2KhSE19hZb3UNW6hgMvP3zw/dYVG3T7WdimP+te9g5vUa
	KfGkf5MuunF6PV337p1i9S6V040X7V5ccLvt9S5aVok9em6Oqkdm0VIuQQclluKMREMt5qLi
	RAAT4u7DzQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQV2TD28CDXY8ZbeYs34Nm8XlhZdY
	LRa2LWGxuLxrDpvFupfTWRxYPV6tnsnqcWLGbxaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsY8w4+WEKY8FJ/opvlz6yNTBe4+li5OSQEDCReNozmx3C
	FpO4cG89WxcjF4eQwHRGiZ2nP7JDOL8YJc50HmYCqWITUJP48uUwWIeIgK7Eque7mEFsZoE6
	iZY3R1lAbGEBD4kHy+YwgtgsAqoSZ/rvgfXyClhKPPq2DMoWlPgx+R4LRK+WxPqdx5kgbHmJ
	zWveMkNcpCCx4+xroDkcQLv0JG4ut4IoEZHY9+Id4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcz8+kdzCuarA4xCjAwajEw9sQ8CZQiDWxrLgy9xCj
	BAezkgiv5yqgEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJJucDU01eSbyhsYmZkaWRmYWRibk5
	acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTD6l+4y2rzkruKKH3GC4bGXnERdTjTqiSke
	+/VrgduUrJ2bajwKlFzWTWZeHKWnIzh3bcjBBcc35Pj0hzbFMRyQ6v+le3djZILmp88Bv17W
	TW19Mc3taWXh3NUdTU0sPGfc65Zzc0x9uswnYL6xUIH512NPrOSOzVFIb60JO31D+8eO7qA7
	nppKLMUZiYZazEXFiQCiNPXhKwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 Documentation/target/tcm_mod_builder.py |    2 +-
 Documentation/trace/ftrace.txt          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 3fe0d81..54d29c1 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -300,7 +300,7 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "	int ret;\n\n"
 	buf += "	if (strstr(name, \"tpgt_\") != name)\n"
 	buf += "		return ERR_PTR(-EINVAL);\n"
-	buf += "	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)\n"
+	buf += "	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)\n"
 	buf += "		return ERR_PTR(-EINVAL);\n\n"
 	buf += "	tpg = kzalloc(sizeof(struct " + fabric_mod_name + "_tpg), GFP_KERNEL);\n"
 	buf += "	if (!tpg) {\n"
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index b937c6e..ea2d35d 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -735,7 +735,7 @@ Here are the available options:
 		 function as well as the function being traced.
 
   print-parent:
-   bash-4000  [01]  1477.606694: simple_strtoul <-strict_strtoul
+   bash-4000  [01]  1477.606694: simple_strtoul <-kstrtoul
 
   noprint-parent:
    bash-4000  [01]  1477.606694: simple_strtoul
@@ -759,7 +759,7 @@ Here are the available options:
             latency-format option is enabled.
 
     bash  4000 1 0 00000000 00010a95 [58127d26] 1720.415ms \
-    (+0.000ms): simple_strtoul (strict_strtoul)
+    (+0.000ms): simple_strtoul (kstrtoul)
 
   raw - This will display raw numbers. This option is best for
 	use with user applications that can translate the raw
-- 
1.7.10.4


