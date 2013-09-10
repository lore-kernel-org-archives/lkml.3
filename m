Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3IJTwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:52:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IJTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:52:01 -0400
Date: Tue, 10 Sep 2013 12:51:43 -0700
From: tip-bot for Chuansheng Liu <tipbot@zytor.com>
Message-ID: <tip-e635be963eb2e9883e8124b75dff0c2e29857a6e@git.kernel.org>
Cc: robinmholt@linux.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        chuansheng.liu@intel.com, fei.li@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robinmholt@linux.com, tglx@linutronix.de, hpa@linux.intel.com,
        chuansheng.liu@intel.com, fei.li@intel.com
In-Reply-To: <1378727380.26153.8.camel@cliu38-desktop-build>
References: <1378727380.26153.8.camel@cliu38-desktop-build>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] reboot:
  Re-enable the function of variable reboot_default
Git-Commit-ID: e635be963eb2e9883e8124b75dff0c2e29857a6e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 10 Sep 2013 12:51:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e635be963eb2e9883e8124b75dff0c2e29857a6e
Gitweb:     http://git.kernel.org/tip/e635be963eb2e9883e8124b75dff0c2e29857a6e
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Mon, 9 Sep 2013 19:49:40 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 10 Sep 2013 08:48:40 -0700

reboot: Re-enable the function of variable reboot_default

Commit 1b3a5d02ee070c (reboot: move arch/x86 reboot= handling to
generic kernel) did some cleanup for reboot= command line, but it made
the reboot_default to be invalidated.

The default value of variable reboot_default should be 1, and if command line
reboot= is not set, system will use the default reboot mode.

Signed-off-by: Li Fei <fei.li@intel.com>
Link: http://lkml.kernel.org/r/1378727380.26153.8.camel@cliu38-desktop-build
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Acked-by: Robin Holt <robinmholt@linux.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/reboot.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 269ed93..d82eb6e 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -32,7 +32,14 @@ EXPORT_SYMBOL(cad_pid);
 #endif
 enum reboot_mode reboot_mode DEFAULT_REBOOT_MODE;
 
-int reboot_default;
+/*
+ * This variable is used privately to keep track of whether or not
+ * reboot_type is still set to its default value (i.e., reboot= hasn't
+ * been set on the command line).  This is needed so that we can
+ * suppress DMI scanning for reboot quirks.  Without it, it's
+ * impossible to override a faulty reboot quirk without recompiling.
+*/
+int reboot_default = 1;
 int reboot_cpu;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
