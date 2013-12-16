Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3LPRH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:07:26 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40153 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab3LPRHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:07:22 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-sctp@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] printk: Add a pr_warn_deprecated macro
Date: Mon, 16 Dec 2013 12:06:44 -0500
Message-Id: <1387213605-27206-2-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387213605-27206-1-git-send-email-nhorman@tuxdriver.com>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
 <1387213605-27206-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sctp has several points in its setsockopt path in which it issues deprecation
warnings.  It seems like it might be handy to macrotize such a warning so other
subsystems can use it easily

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
---
 include/linux/printk.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 6949258..2e043b3 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -336,6 +336,9 @@ extern asmlinkage void dump_stack(void) __cold;
 	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 /* no pr_cont_ratelimited, don't do that... */
 
+#define pr_warn_deprecated(fmt, ...)					\
+	pr_warn_ratelimited("Deprecated: " fmt, ##__VA_ARGS__)
+
 #if defined(DEBUG)
 #define pr_devel_ratelimited(fmt, ...)					\
 	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
-- 
1.8.3.1

