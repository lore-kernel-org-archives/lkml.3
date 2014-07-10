Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaGJUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:16:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48126 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaGJUQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:16:26 -0400
Date: Thu, 10 Jul 2014 13:16:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] staging: r8821ae: avoid leaking format string
Message-ID: <20140710201611.GA31972@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This make sure a format string cannot leak into the work queue name nor
the printk buffer.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is the third time this set of macros has entered the kernel:

drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h
drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h

Can we extract these macros to some common place and keep them from returning?
---
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
index 787798e76217..fd233cc85a5b 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
@@ -88,7 +88,7 @@ extern u32 btc_dbg_type[];
 
 
 #define	CL_SPRINTF	snprintf
-#define	CL_PRINTF	printk
+#define	CL_PRINTF(buf)	printk("%s", buf)
 
 #define	BTC_PRINT(dbgtype, dbgflag, printstr, ...)		\
 	do { 							\
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
