Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab3CYQ4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:56:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38766 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab3CYQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:56:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f076d0000034b6-ea-515081ccdbb7
Content-transfer-encoding: 8BIT
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: sameo@linux.intel.com
Cc: kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Dong Aisheng <dong.aisheng@linaro.org>
Subject: [PATCH] mfd: syscon: Add missing struct device_node declaration
Date: Mon, 25 Mar 2013 17:56:23 +0100
Message-id: <1364230583-4043-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQd0zjQGBBkcfiVssO9fDanG26Q27
	xeVdc9gsDr9pZ7U43c3qwOpx59oeNo95JwM9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK6N/
	WXrBBM6KK3PnMzYwvmHvYuTkkBAwkdiy7AArhC0mceHeerYuRi4OIYHpjBJLd35mBEnwCghK
	/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5gh6juYJC6f62QCSbAJGEr0Hu0D6xURkJR49ngd
	I0gRs8AURomLMzrZQBLCAh4SD262ghWxCKhKHP3ewgyxzFVi7dytrCDLJAQUJOZMspnAyDcL
	yRmzEM6YheSMBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw/GZ9A7GVQ0WhxgFOBiV
	eHg5wgIChVgTy4orcw8xSnAwK4nwagkBhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJI
	TyxJzU5NLUgtgskycXBKNTDaPz9Xrbxu8qR361y//ZgyazqbuXyIRZNny4MzB9m9rXPDJwR+
	1HWZvSpw04zVu+b1WzNny8r9XdaxdlHV1U9Ns9gOGIYErpCZYT5D1OZHYsyqZNNZxc5bXYpq
	ZlUyybHGzX/y6VzSpVVGnfdklxyv27lfK6ORUYP7x4brxnEfxHs51q5TO2urxFKckWioxVxU
	nAgASzZLCkMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscon.h header uses struct device_node in functions' declarations
without declaring it. This causes compilation warnings like:

include/linux/mfd/syscon.h:20: warning: ‘struct device_node’
declared inside parameter list
include/linux/mfd/syscon.h:20: warning: its scope is only this
definition or declaration, which is probably not what you want

Fix it by adding a forward declaration of struct device_node.

Cc: Dong Aisheng <dong.aisheng@linaro.org>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/mfd/syscon.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 6aeb6b8..f7be936 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -15,6 +15,8 @@
 #ifndef __LINUX_MFD_SYSCON_H__
 #define __LINUX_MFD_SYSCON_H__
 
+struct device_node;
+
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
 extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_phandle(
-- 
1.7.9.5

