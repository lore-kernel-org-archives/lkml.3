Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3AXURM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:17:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34470 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3AXUQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:16:57 -0500
Date: Thu, 24 Jan 2013 12:16:45 -0800
From: tip-bot for Bjorn Helgaas <bhelgaas@google.com>
Message-ID: <tip-6125bc8b86d9da75ddac77e38f41afbf9f5de3e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, tglx@linutronix.de
In-Reply-To: <20130104224146.15189.14874.stgit@bhelgaas.mtv.corp.google.com>
References: <20130104224146.15189.14874.stgit@bhelgaas.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86/time/rtc: Don'
 t print extended CMOS year when reading RTC
Git-Commit-ID: 6125bc8b86d9da75ddac77e38f41afbf9f5de3e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:16:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6125bc8b86d9da75ddac77e38f41afbf9f5de3e3
Gitweb:     http://git.kernel.org/tip/6125bc8b86d9da75ddac77e38f41afbf9f5de3e3
Author:     Bjorn Helgaas <bhelgaas@google.com>
AuthorDate: Fri, 4 Jan 2013 15:41:47 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 14:56:35 +0100

x86/time/rtc: Don't print extended CMOS year when reading RTC

We shouldn't print the current century every time we read the
RTC.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130104224146.15189.14874.stgit@bhelgaas.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/rtc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 801602b..2e8f3d3 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -149,7 +149,6 @@ unsigned long mach_get_cmos_time(void)
 	if (century) {
 		century = bcd2bin(century);
 		year += century * 100;
-		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
 	} else
 		year += CMOS_YEARS_OFFS;
 
