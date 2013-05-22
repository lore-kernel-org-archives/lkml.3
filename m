Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3EVXvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 19:51:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39048 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab3EVXvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 19:51:48 -0400
Date: Wed, 22 May 2013 16:51:02 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mtd@lists.infradead.org
Subject: [RESEND][PATCH] mtd: refactor call to request_module
Message-ID: <20130522235102.GA22498@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the size of the stack frame when calling request_module().
Performing the sprintf before the call is not needed.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/mtd/chips/gen_probe.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/chips/gen_probe.c b/drivers/mtd/chips/gen_probe.c
index 74dbb6b..ffb36ba 100644
--- a/drivers/mtd/chips/gen_probe.c
+++ b/drivers/mtd/chips/gen_probe.c
@@ -211,9 +211,7 @@ static inline struct mtd_info *cfi_cmdset_unknown(struct map_info *map,
 
 	probe_function = __symbol_get(probename);
 	if (!probe_function) {
-		char modname[sizeof("cfi_cmdset_%4.4X")];
-		sprintf(modname, "cfi_cmdset_%4.4X", type);
-		request_module(modname);
+		request_module("cfi_cmdset_%4.4X", type);
 		probe_function = __symbol_get(probename);
 	}
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
