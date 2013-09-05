Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935652Ab3IEKQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:16:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44685 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935550Ab3IEKQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:16:53 -0400
Date: Thu, 5 Sep 2013 11:16:49 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
Message-ID: <20130905101649.GL28598@console-pimps.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
 <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Sep, at 07:50:18PM, Matthew Garrett wrote:
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

[...]

> @@ -1129,6 +1129,12 @@ void __init setup_arch(char **cmdline_p)
>  
>  	io_delay_init();
>  
> +#ifdef CONFIG_EFI_SECURE_BOOT_SIG_ENFORCE
> +	if (boot_params.secure_boot) {
> +		enforce_signed_modules();
> +	}
> +#endif
> +

I'd advise checking efi_enabled(EFI_BOOT) along with .secure_boot to
guard against garbage values in boot_params.

-- 
Matt Fleming, Intel Open Source Technology Center
