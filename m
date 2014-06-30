Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaF3MR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:17:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51982 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 055/181] mfd: sm501: dbg_regs attribute must be read-only
Date: Mon, 30 Jun 2014 13:51:16 +0200
Message-Id: <46e47e76722c97c488f77ba3a2b2e77e371860d6.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8a8320c2e78d1b619a8fa8eb5ae946b8691de604 upstream.

Fix:

sm501 sm501: SM501 At b3e00000: Version 050100a0, 8 Mb, IRQ 100
Attribute dbg_regs: write permission without 'store'
------------[ cut here ]------------
WARNING: at drivers/base/core.c:620

dbg_regs does not have a write function and must therefore be marked
as read-only.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/sm501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 33f040c558d0..3799a3d64415 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1232,7 +1232,7 @@ static ssize_t sm501_dbg_regs(struct device *dev,
 }
 
 
-static DEVICE_ATTR(dbg_regs, 0666, sm501_dbg_regs, NULL);
+static DEVICE_ATTR(dbg_regs, 0444, sm501_dbg_regs, NULL);
 
 /* sm501_init_reg
  *
-- 
2.0.0

