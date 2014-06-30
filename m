Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaF3UjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:39:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57955 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaF3UjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:39:14 -0400
Date: Mon, 30 Jun 2014 13:38:49 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RESEND][PATCH] rtlwifi: btcoexist: avoid format string in printk
Message-ID: <20140630203849.GA4787@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since CL_PRINTF only ever takes a single argument, make sure a format
string cannot leak into printk.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h  |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
index 871fc3c6d559..049f4c8d98a8 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -114,7 +114,7 @@ extern u32 btc_dbg_type[];
 
 
 #define	CL_SPRINTF	snprintf
-#define	CL_PRINTF	printk
+#define	CL_PRINTF(buf)	printk("%s", buf)
 
 #define	BTC_PRINT(dbgtype, dbgflag, printstr, ...)		\
 	do {							\
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
