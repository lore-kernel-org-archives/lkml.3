Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaKYKqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:46:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaKYKnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 247/254] clocksource: Remove "weak" from clocksource_default_clock() declaration
Date: Tue, 25 Nov 2014 10:39:57 +0000
Message-Id: <1416912004-5928-248-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/clocksource.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index a16b497d5159..366269d77d7c 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -289,7 +289,7 @@ extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
-extern struct clocksource * __init __weak clocksource_default_clock(void);
+extern struct clocksource * __init clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 extern u64
-- 
2.1.0

