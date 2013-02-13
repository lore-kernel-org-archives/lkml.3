Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3BMCAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:00:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab3BMCAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:00:11 -0500
Date: Tue, 12 Feb 2013 17:58:54 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
References: <tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hyperv] x86, hyperv: HYPERV depends on X86_LOCAL_APIC
Git-Commit-ID: cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Feb 2013 17:59:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78
Gitweb:     http://git.kernel.org/tip/cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 12 Feb 2013 17:46:23 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Feb 2013 17:46:23 -0800

x86, hyperv: HYPERV depends on X86_LOCAL_APIC

In order to compile in the special Hyper-V interrupt vector, we need
infrastructure in arch/x86/apic/apic.c.  At least for now, simply
require CONFIG_X86_LOCAL_APIC in order to enable CONFIG_HYPERV.

Link: http://lkml.kernel.org/r/tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org
Cc: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/hv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index b38ef6d..64630f1 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -2,7 +2,7 @@ menu "Microsoft Hyper-V guest support"
 
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && ACPI && PCI
+	depends on X86 && ACPI && PCI && X86_LOCAL_APIC
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
