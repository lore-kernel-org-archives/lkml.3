Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaBYGCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:02:01 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:65262 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaBYGCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:02:00 -0500
Date: Tue, 25 Feb 2014 13:01:47 +0700
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140225060146.GA4339@debian.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pentium M is PAE capable but does not indicate so in the CPUID response.
This is an issue now that some distributions are no longer shipping
non-PAE kernels (those distributions no longer boot on Pentium M). This
small patch fixes the issue by forcing the PAE capability on Pentium M.

For more discussion see https://bugs.launchpad.net/baltix/+bug/930447

Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>

---

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index bbe1b8b..97996aa 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -226,6 +226,12 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
 
 	/*
+	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
+	 */
+	if ((c->x86 == 6) && ((c->x86_model == 9) || (c->x86_model == 13)))
+		set_cpu_cap(c, X86_FEATURE_PAE);
+
+	/*
 	 * P4 Xeon errata 037 workaround.
 	 * Hardware prefetcher may cause stale data to be loaded into the cache.
 	 */
