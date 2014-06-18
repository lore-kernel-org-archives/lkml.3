Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbaFRUqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:46:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36734 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbaFRUp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:45:57 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org, hpa@linux.intel.com
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH v8 3/4] printk: make dynamic units clear for the kernel ring buffer
Date: Wed, 18 Jun 2014 13:45:36 -0700
Message-Id: <1403124337-14886-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
References: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Suggested-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index af164a7..7bf1365 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -879,7 +879,7 @@ void __init setup_log_buf(int early)
 	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	pr_info("log_buf_len: %d\n", log_buf_len);
+	pr_info("log_buf_len: %d bytes\n", log_buf_len);
 	pr_info("early log buf free: %d(%d%%)\n",
 		free, (free * 100) / __LOG_BUF_LEN);
 }
-- 
1.9.3

