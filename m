Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaAUVmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:42:11 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50672 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaAUVYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wolfram Sang <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>
Subject: [PATCH 30/73] drivers/i2c: busses/i2c-acorn.c is tristate and should use module.h
Date: Tue, 21 Jan 2014 16:22:33 -0500
Message-ID: <1390339396-3479-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is controlled by a tristate Kconfig option, and hence
needs to include module.h so that it can get module_init() once
we relocate it from init.h into module.h in the future.

Note that module_exit() appears to be missing from the driver, so
it is questionable whether it would actually work for a removal
and reload cycle if it was configured for a modular build.

Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/i2c/busses/i2c-acorn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-acorn.c b/drivers/i2c/busses/i2c-acorn.c
index ed9f48d..9d7be5a 100644
--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -12,7 +12,7 @@
  *  On Acorn machines, the following i2c devices are on the bus:
  *	- PCF8583 real time clock & static RAM
  */
-#include <linux/init.h>
+#include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/io.h>
-- 
1.8.4.1

