Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaEVH4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:56:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36631 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbaEVH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:56:24 -0400
Date: Thu, 22 May 2014 08:56:17 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de
Subject: Re: [PATCH v4 4/5] arch/x86: Replace plain strings with constants
Message-ID: <20140522075617.GQ4798@console-pimps.org>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-5-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400272904-31121-5-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May, at 10:41:43PM, Daniel Kiper wrote:
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  arch/x86/kernel/setup.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f41f648..7a67f5d 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -924,11 +924,11 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>  #ifdef CONFIG_EFI
>  	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
> -		     "EL32", 4)) {
> +				EFI32_LOADER_SIGNATURE, 4)) {
>  		set_bit(EFI_BOOT, &efi.flags);
>  		set_bit(EFI_DIRECT, &efi.flags);
>  	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
> -		     "EL64", 4)) {
> +				EFI64_LOADER_SIGNATURE, 4)) {
>  		set_bit(EFI_BOOT, &efi.flags);
>  		set_bit(EFI_DIRECT, &efi.flags);
>  		set_bit(EFI_64BIT, &efi.flags);

Conceptually this change is a nice cleanup, but you've also changed the
indentation. Please don't do that, stick with the existing format.

-- 
Matt Fleming, Intel Open Source Technology Center
