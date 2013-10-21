Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3JUJ0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:26:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39429 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542Ab3JUIvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wladislav Wiebe" <wladislav.kw@gmail.com>,
        "Grant Likely" <grant.likely@linaro.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.169822969@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 040/149] of: Fix missing memory initialization on FDT
 unflattening
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/of/base.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1189,6 +1189,7 @@ void of_alias_scan(void * (*dt_alloc)(u6
 		ap = dt_alloc(sizeof(*ap) + len + 1, 4);
 		if (!ap)
 			continue;
+		memset(ap, 0, sizeof(*ap) + len + 1);
 		ap->alias = start;
 		of_alias_add(ap, np, id, start, len);
 	}

