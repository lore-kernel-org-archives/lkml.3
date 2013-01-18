Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3ARR6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:58:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab3ARR6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:58:51 -0500
Date: Fri, 18 Jan 2013 12:58:47 -0500
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Remove noisy warning from default_send_IPI_mask_logical
Message-ID: <20130118175847.GA27662@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since circa 3.5, we've had dozens of reports of people hitting this warning.
Forwarded reports have been met with silence, so just remove the warning
if no-one cares.

Example reports:
https://bugzilla.redhat.com/show_bug.cgi?id=797687
https://bugzilla.redhat.com/show_bug.cgi?id=867174
https://bugzilla.redhat.com/show_bug.cgi?id=894865

Signed-off-by: Dave Jones <davej@redhat.com>

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
