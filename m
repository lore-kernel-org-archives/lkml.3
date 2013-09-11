Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3IKElt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:41:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35354 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140Ab3IKElr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:41:47 -0400
Date: Tue, 10 Sep 2013 21:41:34 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH] bcache: defensively handle format strings
Message-ID: <20130911044134.GA17310@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to be safe, call the error reporting function with "%s" to avoid
any possible future format string leak.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 547c4c5..5be1de4 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1644,7 +1644,7 @@ err_unlock_gc:
 err:
 	closure_sync(&op.cl);
 	/* XXX: test this, it's broken */
-	bch_cache_set_error(c, err);
+	bch_cache_set_error(c, "%s", err);
 }
 
 static bool can_attach_cache(struct cache *ca, struct cache_set *c)
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
