Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab3KMPu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:50:59 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:32882 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932390Ab3KMPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:50:42 -0500
Date: Wed, 13 Nov 2013 15:50:37 +0000
From: Matt Fleming <matt@console-pimps.org>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 7/7 v2] x86: add xloadflags bit for efi runtime support
 on kexec
Message-ID: <20131113155037.GE17248@console-pimps.org>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082719.416282009@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105082719.416282009@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Nov, at 04:20:14PM, dyoung@redhat.com wrote:
> Old kexec-tools can not load new kernel. The reason is previously kexec-tools
> do not fill efi_info in x86 setup header thus efi init fail and switch
> to noefi boot. In new kexec-tools it will by default fill efi_info and
> pass other efi required infomation to 2nd kernel so kexec kernel efi
> initialization will success finally.
> 
> To prevent from breaking userspace, add a new xloadflags bit so kexec-tools
> will check the flag and switch to old logic.
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/boot/header.S                |    9 ++++++++-
>  arch/x86/include/uapi/asm/bootparam.h |    1 +
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.orig/arch/x86/boot/header.S
> +++ linux-2.6/arch/x86/boot/header.S
> @@ -391,7 +391,14 @@ xloadflags:
>  #else
>  # define XLF23 0
>  #endif
> -			.word XLF0 | XLF1 | XLF23
> +
> +#if defined(CONFIG_X86_64) && defined(CONFIG_EFI)

&& defined(CONFIG_KEXEC) ?

> +# define XLF4 XLF_EFI_KEXEC
> +#else
> +# define XLF4 0
> +#endif
> +

-- 
Matt Fleming, Intel Open Source Technology Center
