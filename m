Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3AXUfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:35:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab3AXUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:34:48 -0500
Date: Thu, 24 Jan 2013 12:34:21 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-13f0e4d2b9e2209f13d5a4122478eb79e6136870@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@kernel.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <50AFB29F02000078000AAE8E@nat28.tlf.novell.com>
References: <50AFB29F02000078000AAE8E@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/EFI: Properly init-annotate BGRT code
Git-Commit-ID: 13f0e4d2b9e2209f13d5a4122478eb79e6136870
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:34:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13f0e4d2b9e2209f13d5a4122478eb79e6136870
Gitweb:     http://git.kernel.org/tip/13f0e4d2b9e2209f13d5a4122478eb79e6136870
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 23 Nov 2012 16:30:07 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 17:12:18 +0100

x86/EFI: Properly init-annotate BGRT code

These items are only ever referenced from initialization code.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: <mjg@redhat.com>
Link: http://lkml.kernel.org/r/50AFB29F02000078000AAE8E@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/efi/efi-bgrt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index d9c1b95..7145ec6 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -11,20 +11,21 @@
  * published by the Free Software Foundation.
  */
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
 
 struct acpi_table_bgrt *bgrt_tab;
-void *bgrt_image;
-size_t bgrt_image_size;
+void *__initdata bgrt_image;
+size_t __initdata bgrt_image_size;
 
 struct bmp_header {
 	u16 id;
 	u32 size;
 } __packed;
 
-void efi_bgrt_init(void)
+void __init efi_bgrt_init(void)
 {
 	acpi_status status;
 	void __iomem *image;
