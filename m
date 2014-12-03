Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaLCL5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:57:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbaLCL1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 059/101] clocksource: Remove "weak" from clocksource_default_clock() declaration
Date: Wed,  3 Dec 2014 12:26:21 +0100
Message-Id: <0f207b54545a7535e02e7ca11931655396e15846.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 96a2adbc6f501996418da9f7afe39bf0e4d006a9 upstream.

kernel/time/jiffies.c provides a default clocksource_default_clock()
definition explicitly marked "weak".  arch/s390 provides its own definition
intended to override the default, but the "weak" attribute on the
declaration applied to the s390 definition as well, so the linker chose one
based on link order (see 10629d711ed7 ("PCI: Remove __weak annotation from
pcibios_get_phb_of_node decl")).

Remove the "weak" attribute from the clocksource_default_clock()
declaration so we always prefer a non-weak definition over the weak one,
independent of link order.

Fixes: f1b82746c1e9 ("clocksource: Cleanup clocksource selection")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/clocksource.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index dbbf8aa7731b..48028261924c 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -289,7 +289,7 @@ extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
-extern struct clocksource * __init __weak clocksource_default_clock(void);
+extern struct clocksource * __init clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 extern void
-- 
2.1.3

