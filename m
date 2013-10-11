Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3JKP0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:26:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55221 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab3JKP0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:26:04 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1381502037-22225-2-git-send-email-matt@console-pimps.org>
References: <1381502037-22225-1-git-send-email-matt@console-pimps.org> <1381502037-22225-2-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] x86/efi: Include linux/efi.h in asm/efi.h
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 11 Oct 2013 08:25:26 -0700
To: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <5a48a2d8-5d1b-4dba-8342-901e1e586ca4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch description doesn't match what the patch does.  We do not normally have the asm file include the linux file, which is what the patch seems to do.

Matt Fleming <matt@console-pimps.org> wrote:
>From: Matt Fleming <matt.fleming@intel.com>
>
>Every file that includes asm/efi.h also includes linux/efi.h. Just
>include linux/efi.h directly and avoid the duplication.
>
>Cc: H. Peter Anvin <hpa@zytor.com>
>Cc: Thomas Gleixner <tglx@linutronix.de>
>Suggested-by: Ingo Molnar <mingo@kernel.org>
>Signed-off-by: Matt Fleming <matt.fleming@intel.com>
>---
> arch/x86/boot/compressed/eboot.c | 1 -
> arch/x86/include/asm/efi.h       | 2 ++
> arch/x86/kernel/setup.c          | 1 -
> arch/x86/platform/efi/efi.c      | 1 -
> arch/x86/platform/efi/efi_32.c   | 1 -
> arch/x86/platform/efi/efi_64.c   | 1 -
> arch/x86/platform/uv/bios_uv.c   | 1 -
> 7 files changed, 2 insertions(+), 6 deletions(-)
>
>diff --git a/arch/x86/boot/compressed/eboot.c
>b/arch/x86/boot/compressed/eboot.c
>index b7388a4..3f1dae2 100644
>--- a/arch/x86/boot/compressed/eboot.c
>+++ b/arch/x86/boot/compressed/eboot.c
>@@ -7,7 +7,6 @@
>  *
>*
>-----------------------------------------------------------------------
>*/
> 
>-#include <linux/efi.h>
> #include <linux/pci.h>
> #include <asm/efi.h>
> #include <asm/setup.h>
>diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
>index 0062a01..b10ea9e 100644
>--- a/arch/x86/include/asm/efi.h
>+++ b/arch/x86/include/asm/efi.h
>@@ -1,6 +1,8 @@
> #ifndef _ASM_X86_EFI_H
> #define _ASM_X86_EFI_H
> 
>+#include <linux/efi.h>
>+
> #ifdef CONFIG_X86_32
> 
> #define EFI_LOADER_SIGNATURE	"EL32"
>diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>index f0de629..35e9883 100644
>--- a/arch/x86/kernel/setup.c
>+++ b/arch/x86/kernel/setup.c
>@@ -37,7 +37,6 @@
> #include <linux/root_dev.h>
> #include <linux/highmem.h>
> #include <linux/module.h>
>-#include <linux/efi.h>
> #include <linux/init.h>
> #include <linux/edd.h>
> #include <linux/iscsi_ibft.h>
>diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>index c7e22ab..543a4d9 100644
>--- a/arch/x86/platform/efi/efi.c
>+++ b/arch/x86/platform/efi/efi.c
>@@ -30,7 +30,6 @@
> 
> #include <linux/kernel.h>
> #include <linux/init.h>
>-#include <linux/efi.h>
> #include <linux/efi-bgrt.h>
> #include <linux/export.h>
> #include <linux/bootmem.h>
>diff --git a/arch/x86/platform/efi/efi_32.c
>b/arch/x86/platform/efi/efi_32.c
>index 40e4469..dd566d1 100644
>--- a/arch/x86/platform/efi/efi_32.c
>+++ b/arch/x86/platform/efi/efi_32.c
>@@ -22,7 +22,6 @@
> #include <linux/kernel.h>
> #include <linux/types.h>
> #include <linux/ioport.h>
>-#include <linux/efi.h>
> 
> #include <asm/io.h>
> #include <asm/desc.h>
>diff --git a/arch/x86/platform/efi/efi_64.c
>b/arch/x86/platform/efi/efi_64.c
>index 39a0e7f..f146de9 100644
>--- a/arch/x86/platform/efi/efi_64.c
>+++ b/arch/x86/platform/efi/efi_64.c
>@@ -23,7 +23,6 @@
> #include <linux/bootmem.h>
> #include <linux/ioport.h>
> #include <linux/module.h>
>-#include <linux/efi.h>
> #include <linux/uaccess.h>
> #include <linux/io.h>
> #include <linux/reboot.h>
>diff --git a/arch/x86/platform/uv/bios_uv.c
>b/arch/x86/platform/uv/bios_uv.c
>index 7666121..e55b074 100644
>--- a/arch/x86/platform/uv/bios_uv.c
>+++ b/arch/x86/platform/uv/bios_uv.c
>@@ -19,7 +19,6 @@
>  *  Copyright (c) Russ Anderson <rja@sgi.com>
>  */
> 
>-#include <linux/efi.h>
> #include <linux/export.h>
> #include <asm/efi.h>
> #include <linux/io.h>

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
