Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3IKEld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:41:33 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59252 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab3IKElb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:41:31 -0400
Date: Tue, 10 Sep 2013 21:38:04 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Billauer <eli.billauer@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Masanari Iida <standby24x7@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: xillybus: fix format string usage
Message-ID: <20130911043804.GA17205@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes sure format string cannot leak into device_create() call.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/xillybus/xillybus_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
index efc5698..7db6f03 100644
--- a/drivers/staging/xillybus/xillybus_core.c
+++ b/drivers/staging/xillybus/xillybus_core.c
@@ -2054,7 +2054,7 @@ static int xillybus_init_chrdev(struct xilly_endpoint *endpoint,
 				       NULL,
 				       MKDEV(major, i),
 				       NULL,
-				       devname);
+				       "%s", devname);
 
 		if (IS_ERR(device)) {
 			pr_warn("xillybus: Failed to create %s "
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
