Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbbA2KsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:48:03 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753281AbbA2I7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 156/176] x86, hyperv: Mark the Hyper-V clocksource as being continuous
Date: Wed, 28 Jan 2015 15:29:46 +0100
Message-Id: <70f9c75300a2004d025e2cd39ef300b537225169.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 32c6590d126836a062b3140ed52d898507987017 upstream.

The Hyper-V clocksource is continuous; mark it accordingly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Acked-by: jasowang@redhat.com
Cc: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org
Cc: olaf@aepfle.de
Cc: apw@canonical.com
Link: http://lkml.kernel.org/r/1421108762-3331-1-git-send-email-kys@microsoft.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/cpu/mshyperv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 71a39f3621ba..647480716ff1 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -63,6 +63,7 @@ static struct clocksource hyperv_cs = {
 	.rating		= 400, /* use this when running on Hyperv*/
 	.read		= read_hv_clock,
 	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init ms_hyperv_init_platform(void)
-- 
2.2.2

