Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaKSUy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:54:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbaKSUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.17 117/141] clocksource: Remove "weak" from clocksource_default_clock() declaration
Date: Wed, 19 Nov 2014 12:52:20 -0800
Message-Id: <20141119205154.518265519@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/clocksource.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -287,7 +287,7 @@ extern struct clocksource* clocksource_g
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_suspend(void);
 extern void clocksource_resume(void);
-extern struct clocksource * __init __weak clocksource_default_clock(void);
+extern struct clocksource * __init clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 extern u64


