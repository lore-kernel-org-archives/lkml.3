Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab3H2Llo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:41:44 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59537 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab3H2Lln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:41:43 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, stable@vger.kernel.org,
        Wladislav Wiebe <wladislav.kw@gmail.com>
Subject: [PATCH] of: Fix missing memory initialization on FDT unflattening
Date: Thu, 29 Aug 2013 12:41:34 +0100
Message-Id: <1377776494-27040-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any calls to dt_alloc() need to be zeroed. This is a temporary fix, but
the allocation function itself needs to zero memory before returning
it. This is a follow up to patch 9e4012752, "of: fdt: fix memory
initialization for expanded DT" which fixed one call site but missed
another.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: stable@vger.kernel.org
Cc: Wladislav Wiebe <wladislav.kw@gmail.com>
---
 drivers/of/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 5c54279..bf8432f 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1629,6 +1629,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 		ap = dt_alloc(sizeof(*ap) + len + 1, 4);
 		if (!ap)
 			continue;
+		memset(ap, 0, sizeof(*ap) + len + 1);
 		ap->alias = start;
 		of_alias_add(ap, np, id, start, len);
 	}
-- 
1.8.1.2

