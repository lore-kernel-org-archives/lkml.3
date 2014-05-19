Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaESS7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:59:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38912 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaESS7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:59:39 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/2] Add a microcode disable chicken bit
Date: Mon, 19 May 2014 20:59:15 +0200
Message-Id: <1400525957-11525-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

so there are situations where we want to be able to turn off the
microcode loader, especially the early part, to rule out any possible
influence from it accessing ucode blobs early from the initrd and/or
having other effects on the system.

These patches add a "dis_ucode_ldr" (when early loading is not built in,
use with the prefix, i.e. "microcode.dis_ucode_ldr") which enables that.

For that we needed a fairly self-contained cmdline parsing function
which we almost copied from arch/x86/boot/cmdline.c

The dancing in check_loader_disabled_*() variants is needed because on
32-bit we're running before paging is enabled and there we need to deal
with physical addresses.

As always, any comments and suggestions are appreciated.

Thanks.

Borislav Petkov (2):
  x86: Carve out cmdline parsing function
  x86, microcode: Add a disable chicken bit

 arch/x86/include/asm/cmdline.h             |  6 +++
 arch/x86/include/asm/microcode.h           |  1 +
 arch/x86/kernel/cpu/microcode/core.c       |  6 +++
 arch/x86/kernel/cpu/microcode/core_early.c | 37 +++++++++++++
 arch/x86/lib/Makefile                      |  2 +-
 arch/x86/lib/cmdline.c                     | 84 ++++++++++++++++++++++++++++++
 6 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/cmdline.h
 create mode 100644 arch/x86/lib/cmdline.c

-- 
1.9.0

