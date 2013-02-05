Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935Ab3BEFOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:14:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2463 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3BEFOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:14:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6690091"
From: liguang <lig.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Cc: rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH] acpi: change Makefile for srat.c building
Date: Tue, 5 Feb 2013 13:13:47 +0800
Message-Id: <1360041227-7831-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:13:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:13:19,
	Serialize complete at 2013/02/05 13:13:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is an addition of the previous
patch-set v2 acpi: do some changes for numa info,
aimed to bring back the lost Makefile changes.
mail-archive-address:
http://lkml.indiana.edu/hypermail/linux/kernel/1302.0/02107.html

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 arch/x86/kernel/acpi/Makefile |    1 +
 arch/x86/mm/Makefile          |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index 163b225..e24b64d 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_ACPI)		+= boot.o
 obj-$(CONFIG_ACPI_SLEEP)	+= sleep.o wakeup_$(BITS).o
+obj-$(CONFIG_ACPI_NUMA)     += srat.o
 
 ifneq ($(CONFIG_ACPI_PROCESSOR),)
 obj-y				+= cstate.o
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 23d8e5f..d6f3692 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -24,7 +24,6 @@ obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
 obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
 obj-$(CONFIG_AMD_NUMA)		+= amdtopology.o
-obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_MEMTEST)		+= memtest.o
-- 
1.7.2.5

