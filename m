Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3IWKPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:15:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22043 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3IWKPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:15:06 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-9b-524014a971a9
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        t.figa@samsung.com, m.szyprowski@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] DT: if dt is available don't use s3c_arch_init
Date: Mon, 23 Sep 2013 12:14:49 +0200
Message-id: <1379931289-29384-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO5KEYcgg58fdC0mrTvAZNG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8WM8/uYLG5f5rU4veYUs8XaI3fZLdbPeM3iwOXR0tzD5vF31Qtm
	j81L6j0OvtvD5NG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZ3zZ2MxW8Z6uY3b2XqYHxHmsX
	IyeHhICJxPsZh1ggbDGJC/fWs3UxcnEICUxnlPiz6iErhNPOJLHk6kImkCo2AXOJic82gXWI
	CEhKNDX8YQaxmQVWMUm8nRUCYgsL2Ev8PfmODcRmEVCV+NnyjRHE5hXwk/j5rJMdYpuCxM/L
	J9gmMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcSs+kdjCubLA4xCjAwajEwxuR
	aB8kxJpYVlyZe4hRgoNZSYTXj9UhSIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS
	1OzU1ILUIpgsEwenVAPjpBYrjzgtRpMdhjc1/i6U/mV3cfP7/TuFPR5veZOhm6bZv8PygPHp
	dsNwv545KknC18WMpLf/vxyrOsFU9W5q6R7lyU5fWv5Pl38qzr6n5qSuNk/SjogDG+er7hXb
	v57LZtd1CzGnmeWXZ02QtUttvnOCn7ngzmL7/s1H9gY8LOM6+Pji61BxJZbijERDLeai4kQA
	4PPVMSECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It prevents from executing platform code, when booting from device tree.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-samsung/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
index aa9511b..0ace02d 100644
--- a/arch/arm/plat-samsung/init.c
+++ b/arch/arm/plat-samsung/init.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
+#include <linux/of.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
@@ -152,6 +153,8 @@ static int __init s3c_arch_init(void)
 {
 	int ret;
 
+	if (of_have_populated_dt())
+		return 0;
 	// do the correct init for cpu
 
 	if (cpu == NULL) {
-- 
1.8.1.2

