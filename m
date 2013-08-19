Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3HSUG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:06:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab3HSUG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:06:57 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1376942419-5684-1-git-send-email-linn@hp.com>
References: <1376942419-5684-1-git-send-email-linn@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 0/4] EFI boot stub memory map fix
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 19 Aug 2013 22:06:09 +0200
To: Linn Crosetto <linn@hp.com>, matt.fleming@intel.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, linux-efi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Message-ID: <e7fc4e2f-4cda-4eef-8d37-bb87773f58e8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would strongly disagree that option 2 is the cleaner solution.

Linn Crosetto <linn@hp.com> wrote:
>I realize the EFI stub for ARM patches are in flight, 
>
>https://lkml.org/lkml/2013/8/9/554
>
>and overlap with some of the files but I wanted to send these out for
>comment.
>
>This series fixes a problem with EFI memory maps larger than 128
>entries when
>booting using the EFI boot stub, which results in overflowing the
>e820_map in
>boot_params and an eventual halt when checking the map size in
>sanitize_e820_map().
>
>The fix implemented is to add the EFI memory map from setup_arch() via
>a
>memory_setup hook.
>
>Two options were considered:
>
> 1. Use the SETUP_E820_EXT setup_data type to add the extra entries.
>
>2. Create a memory_setup function to be enabled when the EFI memory map
>is
>    needed.
>
>Option 2 appeared to be the cleaner solution, reducing duplication with
>existing code, given a reasonable mechanism for determining when to
>replace the default memory_setup function.
>
>
>Linn Crosetto (4):
>  efi: Decouple efi_memmap_init() and do_add_efi_memmap()
>  efi: Add memory_setup function efi_memory_setup()
>  efi: Add efi_memmap_needed()
>  x86: Fix EFI boot stub for large memory maps
>
>arch/x86/boot/compressed/eboot.c | 64
>++--------------------------------------
> arch/x86/kernel/setup.c          |  3 ++
> arch/x86/platform/efi/efi.c      | 51 +++++++++++++++++++++++---------
> include/linux/efi.h              |  2 ++
> 4 files changed, 45 insertions(+), 75 deletions(-)

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
