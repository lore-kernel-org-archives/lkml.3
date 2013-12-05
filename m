Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3LEMxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:53:40 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62652 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3LEMxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:53:37 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/3] doc: arm64: add description of EFI stub support
To: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org
Cc: matt.fleming@intel.com, patches@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org,
        linux-efi@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mark Salter <msalter@redhat.com>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1385762712-17043-3-git-send-email-msalter@redhat.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com> < 1385762712-17043-3-git-send-email-msalter@redhat.com>
Date: Thu, 05 Dec 2013 12:53:32 +0000
Message-Id: <20131205125332.5977FC407BC@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013 17:05:11 -0500, Mark Salter <msalter@redhat.com> wrote:

Even documentation updates should have a mildly sane commit text. State
why these changes came about. Give a future reader at least some clues
as to why these changes were made now.

Otherwise:

Acked-by: Grant Likely <grant.likely@linaro.org>

g.

> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: linux-arm-kernel@lists.infradead.org
> CC: matt.fleming@intel.com
> CC: linux-efi@vger.kernel.org
> CC: linux-doc@vger.kernel.org
> CC: Rob Landley <rob@landley.net> 
> CC: Leif Lindholm <leif.lindholm@linaro.org>
> CC: roy.franz@linaro.org
> ---
>  Documentation/arm64/booting.txt |  4 ++++
>  Documentation/efi-stub.txt      | 10 ++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> index a9691cc..aa95d38c 100644
> --- a/Documentation/arm64/booting.txt
> +++ b/Documentation/arm64/booting.txt
> @@ -85,6 +85,10 @@ The decompressed kernel image contains a 64-byte header as follows:
>  Header notes:
>  
>  - code0/code1 are responsible for branching to stext.
> +- when booting through EFI, code0/code1 are initially skipped.
> +  res5 is an offset to the PE header and the PE header has the EFI
> +  entry point (efi_stub_entry). When the stub has done its work, it
> +  jumps to code0 to resume the normal boot process.
>  
>  The image must be placed at the specified offset (currently 0x80000)
>  from the start of the system RAM and called there. The start of the
> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> index 19e897c..c2a4b11 100644
> --- a/Documentation/efi-stub.txt
> +++ b/Documentation/efi-stub.txt
> @@ -12,6 +12,11 @@ arch/arm/boot/compressed/efi-header.S and
>  arch/arm/boot/compressed/efi-stub.c.  EFI stub code that is shared
>  between architectures is in drivers/firmware/efi/efi-stub-helper.c.
>  
> +For arm64, there is no compressed kernel support, so the Image itself
> +masquerades as a PE/COFF image and the EFI stub is linked into the
> +kernel. The arm64 EFI stub lives in arch/arm64/kernel/efi-entry.S
> +and arch/arm64/kernel/efi-stub.c.
> +
>  By using the EFI boot stub it's possible to boot a Linux kernel
>  without the use of a conventional EFI boot loader, such as grub or
>  elilo. Since the EFI boot stub performs the jobs of a boot loader, in
> @@ -28,7 +33,8 @@ the extension the EFI firmware loader will refuse to execute it. It's
>  not possible to execute bzImage.efi from the usual Linux file systems
>  because EFI firmware doesn't have support for them.  For ARM the
>  arch/arm/boot/zImage should be copied to the system partition, and it
> -may not need to be renamed.
> +may not need to be renamed. Similarly for arm64, arch/arm64/boot/Image
> +should be copied but not necessarily renamed.
>  
>  
>  **** Passing kernel parameters from the EFI shell
> @@ -72,7 +78,7 @@ is passed to bzImage.efi.
>  
>  **** The "dtb=" option
>  
> -For the ARM architecture, we also need to be able to provide a device
> +For ARM and arm64 architecture, we also need to be able to provide a device
>  tree to the kernel.  This is done with the "dtb=" command line option,
>  and is process in the same manner as the "initrd=" option that is described
>  above.
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

