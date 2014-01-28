Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaA1XPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:15:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaA1XPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:15:42 -0500
Date: Tue, 28 Jan 2014 15:15:29 -0800
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-790ed7421a973d9773dda8b4e5300c3f7f6fbcf7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bhelgaas@google.com, david.a.cohen@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, david.a.cohen@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1390950567-12821-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1390950567-12821-1-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid: Cleanup some platform code'
 s header files
Git-Commit-ID: 790ed7421a973d9773dda8b4e5300c3f7f6fbcf7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 15:15:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  790ed7421a973d9773dda8b4e5300c3f7f6fbcf7
Gitweb:     http://git.kernel.org/tip/790ed7421a973d9773dda8b4e5300c3f7f6fbcf7
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Tue, 28 Jan 2014 15:09:27 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 28 Jan 2014 15:13:40 -0800

x86, intel-mid: Cleanup some platform code's header files

platform_ipc.h and platform_msic.h are wrongly declaring functions as
external and with 'weak' attribute. This patch does a cleanup on those
header files.

It should have no functional change.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1390950567-12821-1-git-send-email-david.a.cohen@linux.intel.com
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/intel-mid/device_libs/platform_ipc.h  | 5 +++--
 arch/x86/platform/intel-mid/device_libs/platform_msic.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/intel-mid/device_libs/platform_ipc.h b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
index 8f568dd..79bb09d 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
+++ b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
@@ -12,6 +12,7 @@
 #ifndef _PLATFORM_IPC_H_
 #define _PLATFORM_IPC_H_
 
-extern void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
-			struct devs_id *dev) __attribute__((weak));
+void __init
+ipc_device_handler(struct sfi_device_table_entry *pentry, struct devs_id *dev);
+
 #endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic.h b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
index 917eb56..b7be1d0 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic.h
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
@@ -14,6 +14,6 @@
 
 extern struct intel_msic_platform_data msic_pdata;
 
-extern void *msic_generic_platform_data(void *info,
-			enum intel_msic_block block) __attribute__((weak));
+void *msic_generic_platform_data(void *info, enum intel_msic_block block);
+
 #endif
