Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3LEPTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:19:31 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62302 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3LEPT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:19:28 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH V5 1/6] efi-stub.txt updates for ARM
To: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        patches@linaro.org, Roy Franz <roy.franz@linaro.org>
In-Reply-To: <1385595115-21488-2-git-send-email-roy.franz@linaro.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org> < 1385595115-21488-2-git-send-email-roy.franz@linaro.org>
Date: Thu, 05 Dec 2013 15:19:23 +0000
Message-Id: <20131205151923.E5B9CC40785@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 15:31:50 -0800, Roy Franz <roy.franz@linaro.org> wrote:
> Update efi-stub.txt documentation to be more general
> and not x86 specific.  Add ARM only "dtb=" command
> line option description.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  Documentation/efi-stub.txt |   27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
> index 44e6bb6..19e897c 100644
> --- a/Documentation/efi-stub.txt
> +++ b/Documentation/efi-stub.txt
> @@ -1,13 +1,16 @@
>  			  The EFI Boot Stub
>  		     ---------------------------
>  
> -On the x86 platform, a bzImage can masquerade as a PE/COFF image,
> -thereby convincing EFI firmware loaders to load it as an EFI
> -executable. The code that modifies the bzImage header, along with the
> -EFI-specific entry point that the firmware loader jumps to are
> -collectively known as the "EFI boot stub", and live in
> +On the x86 and ARM platforms, a kernel zImage/bzImage can masquerade
> +as a PE/COFF image, thereby convincing EFI firmware loaders to load
> +it as an EFI executable. The code that modifies the bzImage header,
> +along with the EFI-specific entry point that the firmware loader
> +jumps to are collectively known as the "EFI boot stub", and live in
>  arch/x86/boot/header.S and arch/x86/boot/compressed/eboot.c,
> -respectively.
> +respectively.  For ARM the EFI stub is implemented in
> +arch/arm/boot/compressed/efi-header.S and
> +arch/arm/boot/compressed/efi-stub.c.  EFI stub code that is shared
> +between architectures is in drivers/firmware/efi/efi-stub-helper.c.
>  
>  By using the EFI boot stub it's possible to boot a Linux kernel
>  without the use of a conventional EFI boot loader, such as grub or
> @@ -23,7 +26,9 @@ The bzImage located in arch/x86/boot/bzImage must be copied to the EFI
>  System Partiion (ESP) and renamed with the extension ".efi". Without
>  the extension the EFI firmware loader will refuse to execute it. It's
>  not possible to execute bzImage.efi from the usual Linux file systems
> -because EFI firmware doesn't have support for them.
> +because EFI firmware doesn't have support for them.  For ARM the
> +arch/arm/boot/zImage should be copied to the system partition, and it
> +may not need to be renamed.
>  
>  
>  **** Passing kernel parameters from the EFI shell
> @@ -63,3 +68,11 @@ Notice how bzImage.efi can be specified with a relative path. That's
>  because the image we're executing is interpreted by the EFI shell,
>  which understands relative paths, whereas the rest of the command line
>  is passed to bzImage.efi.
> +
> +
> +**** The "dtb=" option
> +
> +For the ARM architecture, we also need to be able to provide a device
> +tree to the kernel.  This is done with the "dtb=" command line option,
> +and is process in the same manner as the "initrd=" option that is described
> +above.
> -- 
> 1.7.10.4
> 

