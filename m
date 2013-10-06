Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3JFTid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 15:38:33 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:51663 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab3JFTic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 15:38:32 -0400
Date: Sun, 6 Oct 2013 13:38:24 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: [PATCH 1/2] tpm: Rename tpm.c to tpm-interface.c
Message-ID: <20131006193824.GA19123@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation for making the tpm module multi-file. kbuild does
not like having a .c file with the same name as a module. We wish to
keep the tpm module name so that userspace doesn't see this change.

tpm-interface.c is chosen because the next several commits in the series
migrate items into tpm-sysfs.c, tpm-dev.c and tpm-class.c. All that will
be left is tpm command processing and interfacing code.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/Makefile                   | 2 ++
 drivers/char/tpm/{tpm.c => tpm-interface.c} | 0
 2 files changed, 2 insertions(+)
 rename drivers/char/tpm/{tpm.c => tpm-interface.c} (100%)

This patch fits into the earlier posted series, see:
https://github.com/jgunthorpe/linux/commits/for-tpm

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index eb41ff9..83b8a9d 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
+tpm-y := tpm-interface.o
+
 ifdef CONFIG_ACPI
 	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
 	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o tpm_ppi.o
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm-interface.c
similarity index 100%
rename from drivers/char/tpm/tpm.c
rename to drivers/char/tpm/tpm-interface.c
-- 
1.8.1.2

