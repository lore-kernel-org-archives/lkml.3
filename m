Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3AXUHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:07:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34298 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3AXUHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:07:43 -0500
Date: Thu, 24 Jan 2013 12:07:28 -0800
From: tip-bot for Dave Jones <davej@redhat.com>
Message-ID: <tip-e3f0f36ddf1b2743a0d4ea312996536a9c37e1c7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <20130118175847.GA27662@redhat.com>
References: <20130118175847.GA27662@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Remove noisy zero-mask warning from default_send_IPI_mask_logical()
Git-Commit-ID: e3f0f36ddf1b2743a0d4ea312996536a9c37e1c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:07:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3f0f36ddf1b2743a0d4ea312996536a9c37e1c7
Gitweb:     http://git.kernel.org/tip/e3f0f36ddf1b2743a0d4ea312996536a9c37e1c7
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Fri, 18 Jan 2013 12:58:47 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 12:12:42 +0100

x86/apic: Remove noisy zero-mask warning from default_send_IPI_mask_logical()

Since circa 3.5, we've had dozens of reports of people hitting
this warning. Forwarded reports have been met with silence, so
just remove the warning if no-one cares.

Example reports:

  https://bugzilla.redhat.com/show_bug.cgi?id=797687
  https://bugzilla.redhat.com/show_bug.cgi?id=867174
  https://bugzilla.redhat.com/show_bug.cgi?id=894865

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130118175847.GA27662@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/ipi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index cce91bf..7434d85 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -106,7 +106,7 @@ void default_send_IPI_mask_logical(const struct cpumask *cpumask, int vector)
 	unsigned long mask = cpumask_bits(cpumask)[0];
 	unsigned long flags;
 
-	if (WARN_ONCE(!mask, "empty IPI mask"))
+	if (!mask)
 		return;
 
 	local_irq_save(flags);
