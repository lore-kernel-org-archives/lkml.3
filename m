Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763561Ab3IEIXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:23:44 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:51336 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763390Ab3IEIXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:23:41 -0400
Subject: Re: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
In-Reply-To: <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Sep 2013 16:24:28 +0800
Message-ID: <1378369468.6193.3.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2013-09-03 於 19:50 -0400，Matthew Garrett 提到：
> UEFI Secure Boot provides a mechanism for ensuring that the firmware will
> only load signed bootloaders and kernels. Certain use cases may also
> require that all kernel modules also be signed. Add a configuration option
> that enforces this automatically when enabled.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  Documentation/x86/zero-page.txt       |  2 ++
>  arch/x86/Kconfig                      | 10 ++++++++++
>  arch/x86/boot/compressed/eboot.c      | 36 +++++++++++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/bootparam.h |  3 ++-
>  arch/x86/kernel/setup.c               |  6 ++++++
>  include/linux/module.h                |  6 ++++++
>  kernel/module.c                       |  7 +++++++
>  7 files changed, 69 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
> index 199f453..ec38acf 100644
> --- a/Documentation/x86/zero-page.txt
> +++ b/Documentation/x86/zero-page.txt
> @@ -30,6 +30,8 @@ Offset	Proto	Name		Meaning
>  1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
>  1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
>  				(below)
> +1EB/001	ALL     kbd_status      Numlock is enabled
> +1EC/001	ALL     secure_boot	Secure boot is enabled in the firmware
>  1EF/001	ALL	sentinel	Used to detect broken bootloaders
>  290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
>  2D0/A00	ALL	e820_map	E820 memory map table
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b32ebf9..6a6c19b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1581,6 +1581,16 @@ config EFI_STUB
>  
>  	  See Documentation/x86/efi-stub.txt for more information.
>  
> +config EFI_SECURE_BOOT_SIG_ENFORCE
> +        def_bool n

Maybe need add "select MODULE_SIG" to here for auto enable kernel module
signature check when user select this option?

> +	prompt "Force module signing when UEFI Secure Boot is enabled"
> +	---help---
> +	  UEFI Secure Boot provides a mechanism for ensuring that the
> +	  firmware will only load signed bootloaders and kernels. Certain
> +	  use cases may also require that all kernel modules also be signed.
> +	  Say Y here to automatically enable module signature enforcement
> +	  when a system boots with UEFI Secure Boot enabled.

Thanks a lot!
Joey Lee

