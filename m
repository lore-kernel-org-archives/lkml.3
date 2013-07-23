Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab3GWU7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:59:34 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:56878 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab3GWU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:59:28 -0400
Date: Tue, 23 Jul 2013 22:59:23 +0200
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86, microcode: Don't lose error returns in
 save_microcode_in_initrd()
Message-ID: <20130723225923.352bc442@googlemail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't lose the error return.
This was lost when early amd microcode loading was added in
757885e94a22bcc82beb9b1445c95218cb20ceab

Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

--- a/arch/x86/kernel/microcode_core_early.c	2013-07-23 19:44:05.509516795 +0200
+++ b/arch/x86/kernel/microcode_core_early.c	2013-07-23 19:58:34.459509474 +0200
@@ -127,11 +127,11 @@ int __init save_microcode_in_initrd(void
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		if (c->x86 >= 6)
-			save_microcode_in_initrd_intel();
+			return save_microcode_in_initrd_intel();
 		break;
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0x10)
-			save_microcode_in_initrd_amd();
+			return save_microcode_in_initrd_amd();
 		break;
 	default:
 		break;
