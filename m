Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaJORGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:06:33 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:62259 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaJORG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:06:26 -0400
Subject: [PATCH v1 06/10] clocksource: Remove "weak" from
 clocksource_default_clock() declaration
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:06:24 -0600
Message-ID: <20141015170624.4063.24678.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/clocksource.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 653f0e2b6ca9..abcafaa20b86 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -287,7 +287,7 @@ extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
-extern struct clocksource * __init __weak clocksource_default_clock(void);
+extern struct clocksource * __init clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 extern u64

