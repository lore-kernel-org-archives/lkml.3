Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3ITU0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:26:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41564 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3ITUOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Grant Likely <grant.likely@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 41/93] of: Fix missing memory initialization on FDT unflattening
Date: Fri, 20 Sep 2013 13:08:36 -0700
Message-Id: <1379707768-1804-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grant Likely <grant.likely@linaro.org>

commit 0640332e073be9207f0784df43595c0c39716e42 upstream.

Any calls to dt_alloc() need to be zeroed. This is a temporary fix, but
the allocation function itself needs to zero memory before returning
it. This is a follow up to patch 9e4012752, "of: fdt: fix memory
initialization for expanded DT" which fixed one call site but missed
another.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Acked-by: Wladislav Wiebe <wladislav.kw@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/of/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 2390ddb..8d6faae 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1482,6 +1482,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 		ap = dt_alloc(sizeof(*ap) + len + 1, 4);
 		if (!ap)
 			continue;
+		memset(ap, 0, sizeof(*ap) + len + 1);
 		ap->alias = start;
 		of_alias_add(ap, np, id, start, len);
 	}
-- 
1.8.1.2

