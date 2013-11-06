Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3KFSGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:06:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab3KFSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:06:51 -0500
Date: Wed, 6 Nov 2013 10:06:33 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-4c08edd305019061bf1ac95ce089497bdbb8b8ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381444224-3303-1-git-send-email-kys@microsoft.com>
References: <1381444224-3303-1-git-send-email-kys@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hyperv] x86, hyperv:
  Move a variable to avoid an unused variable warning
Git-Commit-ID: 4c08edd305019061bf1ac95ce089497bdbb8b8ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 10:06:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c08edd305019061bf1ac95ce089497bdbb8b8ac
Gitweb:     http://git.kernel.org/tip/4c08edd305019061bf1ac95ce089497bdbb8b8ac
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 6 Nov 2013 10:00:05 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Nov 2013 10:02:05 -0800

x86, hyperv: Move a variable to avoid an unused variable warning

The variable hv_lapic_frequency causes an unused variable warning if
CONFIG_X86_LOCAL_APIC is disabled.  Since the variable is only used
inside a small if statement, move the declaration of that variable
into the if statement itself.

Cc: K. Y. Srinivasan <kys@microsoft.com>
Link: http://lkml.kernel.org/r/1381444224-3303-1-git-send-email-kys@microsoft.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 9f6e9f8..9f7ca26 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -70,8 +70,6 @@ static struct clocksource hyperv_cs = {
 
 static void __init ms_hyperv_init_platform(void)
 {
-	u64	hv_lapic_frequency;
-
 	/*
 	 * Extract the features and hints
 	 */
@@ -86,6 +84,8 @@ static void __init ms_hyperv_init_platform(void)
 		/*
 		 * Get the APIC frequency.
 		 */
+		u64	hv_lapic_frequency;
+
 		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, hv_lapic_frequency);
 		hv_lapic_frequency = div_u64(hv_lapic_frequency, HZ);
 		lapic_timer_frequency = hv_lapic_frequency;
