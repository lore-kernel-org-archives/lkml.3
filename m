Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3KVCtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:49:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab3KVCtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:49:51 -0500
Date: Fri, 22 Nov 2013 10:48:50 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 5/9 v3] efi: export more efi table variable to sysfs
Message-ID: <20131122024850.GC3874@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
 <20131121165742.GN26009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121165742.GN26009@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/13 at 05:57pm, Borislav Petkov wrote:
> On Thu, Nov 21, 2013 at 02:17:09PM +0800, dyoung@redhat.com wrote:
> > --- efi.orig/arch/x86/platform/efi/efi.c
> > +++ efi/arch/x86/platform/efi/efi.c
> > @@ -653,6 +653,10 @@ void __init efi_init(void)
> >  
> >  	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
> >  
> > +	efi.fw_vendor = (unsigned long)efi.systab->fw_vendor;
> > +	efi.runtime = (unsigned long)efi.systab->runtime;
> > +	efi.config_table = (unsigned long)efi.systab->tables;
> 
> A bit more readable:
> 
> 	efi.config_table = (unsigned long)efi.systab->tables;
> 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
> 	efi.runtime	 = (unsigned long)efi.systab->runtime;

Hmm, UEFI spec mentions the them like below so I use the order:

Several fields of the EFI System Table must be converted from
physical pointers to virtual pointers using the ConvertPointer()
service. These fields include FirmwareVendor, RuntimeServices,
and ConfigurationTable.

But since you like the reverse I can change it in next version.

--
Thanks for review
Dave
