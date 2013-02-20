Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935656Ab3BTOAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:00:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114Ab3BTOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:00:48 -0500
Date: Wed, 20 Feb 2013 05:59:22 -0800
From: tip-bot for Mathias Krause <tipbot@zytor.com>
Message-ID: <tip-27cf929845b10043f2257693c7d179a9e0b1980e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pageexec@freemail.hu, minipli@googlemail.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        minipli@googlemail.com, suresh.b.siddha@intel.com,
        pageexec@freemail.hu, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <1361303227-13174-1-git-send-email-minipli@googlemail.com>
References: <1361303227-13174-1-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/apic: Fix parsing of the 'lapic'
  cmdline option
Git-Commit-ID: 27cf929845b10043f2257693c7d179a9e0b1980e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 20 Feb 2013 05:59:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27cf929845b10043f2257693c7d179a9e0b1980e
Gitweb:     http://git.kernel.org/tip/27cf929845b10043f2257693c7d179a9e0b1980e
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Tue, 19 Feb 2013 20:47:07 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Feb 2013 11:24:36 +0100

x86/apic: Fix parsing of the 'lapic' cmdline option

Including " lapic " in the kernel cmdline on an x86-64 kernel
makes it panic while parsing early params -- e.g. with no user
visible output.

Fix this bug by ensuring arg is non-NULL before passing it to
strncmp().

Reported-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1361303227-13174-1-git-send-email-minipli@googlemail.com
Cc: stable@vger.kernel.org	# v3.8
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a5b4dce..904611b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -131,7 +131,7 @@ static int __init parse_lapic(char *arg)
 {
 	if (config_enabled(CONFIG_X86_32) && !arg)
 		force_enable_local_apic = 1;
-	else if (!strncmp(arg, "notscdeadline", 13))
+	else if (arg && !strncmp(arg, "notscdeadline", 13))
 		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 	return 0;
 }
