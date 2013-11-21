Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3KUQ5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:57:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59125 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3KUQ5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:57:50 -0500
Date: Thu, 21 Nov 2013 17:57:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 5/9 v3] efi: export more efi table variable to sysfs
Message-ID: <20131121165742.GN26009@pd.tnic>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:17:09PM +0800, dyoung@redhat.com wrote:
> --- efi.orig/arch/x86/platform/efi/efi.c
> +++ efi/arch/x86/platform/efi/efi.c
> @@ -653,6 +653,10 @@ void __init efi_init(void)
>  
>  	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
>  
> +	efi.fw_vendor = (unsigned long)efi.systab->fw_vendor;
> +	efi.runtime = (unsigned long)efi.systab->runtime;
> +	efi.config_table = (unsigned long)efi.systab->tables;

A bit more readable:

	efi.config_table = (unsigned long)efi.systab->tables;
	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
	efi.runtime	 = (unsigned long)efi.systab->runtime;

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
