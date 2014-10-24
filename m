Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbaJXWhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:37:05 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60719 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaJXWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:37:03 -0400
Date: Fri, 24 Oct 2014 17:34:56 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 7/7] staging: skein: Removes skein_debug include
Message-ID: <11468e1b3923e05c6683dd388136b9ba925aff10.1414189566.git.eric.rost@mybabylon.net>
References: <cover.1414189566.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414189566.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes skein_debug.h include since skein_debug.h is nonexistent.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/skein_base.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/skein/skein_base.h b/drivers/staging/skein/skein_base.h
index 0111fa4..5b69e5a 100644
--- a/drivers/staging/skein/skein_base.h
+++ b/drivers/staging/skein/skein_base.h
@@ -15,10 +15,6 @@
 **
 ** The "default" note explains what happens when the switch is not defined.
 **
-**  SKEIN_DEBUG            -- make callouts from inside Skein code
-**                            to examine/display intermediate values.
-**                            [default: no callouts (no overhead)]
-**
 **  SKEIN_ERR_CHECK        -- how error checking is handled inside Skein
 **                            code. If not defined, most error checking
 **                            is disabled (for performance). Otherwise,
@@ -282,15 +278,12 @@ int skein_1024_output(struct skein_1024_ctx *ctx, u8 *hash_val);
 /*****************************************************************
 ** "Internal" Skein definitions for debugging and error checking
 ******************************************************************/
-#ifdef SKEIN_DEBUG             /* examine/display intermediate values? */
-#include "skein_debug.h"
-#else                           /* default is no callouts */
 #define skein_show_block(bits, ctx, x, blk_ptr, w_ptr, ks_event_ptr, ks_odd_ptr)
 #define skein_show_round(bits, ctx, r, x)
 #define skein_show_r_ptr(bits, ctx, r, x_ptr)
 #define skein_show_final(bits, ctx, cnt, out_ptr)
 #define skein_show_key(bits, ctx, key, key_bytes)
-#endif
+
 
 /* ignore all asserts, for performance */
 #define skein_assert_ret(x, ret_code)
-- 
2.1.1

