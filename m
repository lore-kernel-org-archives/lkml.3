Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3LEUxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:53:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40899 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3LEUxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:53:00 -0500
Date: Thu, 5 Dec 2013 21:52:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Toshi Kani <toshi.kani@hp.com>, Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131205205250.GF14407@pd.tnic>
References: <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
 <1386023600.1791.201.camel@misato.fc.hp.com>
 <1386034289.1791.210.camel@misato.fc.hp.com>
 <20131203015613.GB3980@dhcp-16-126.nay.redhat.com>
 <1386085140.1791.218.camel@misato.fc.hp.com>
 <20131204024610.GA3764@dhcp-16-126.nay.redhat.com>
 <1386175428.1791.225.camel@misato.fc.hp.com>
 <20131205015615.GC3736@dhcp-16-126.nay.redhat.com>
 <20131205115124.GC14407@pd.tnic>
 <1386258962.1791.268.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386258962.1791.268.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 08:56:02AM -0700, Toshi Kani wrote:
> The smbios in efi_setup_data is necessary for kexec to pass the physical
> address of the SMBIOS table from the 1st kernel to the 2nd kernel.
> 
> The kernel boot sequence proceeds in the following order.  Step 2
> requires efi.smbios to be the physical address.  However, Dave found
> that EFI system table has a virtual address of SMBIOS in step 1.  Hence,
> he sets it back to the physical address with the smbios in
> efi_setup_data.  (When it is still the physical address, it simply sets
> the same value.)
> 
> 1. efi_init() - Set efi.smbios from EFI system table
> 2. dmi_scan_machine() - Temporary map efi.smbios to access SMBIOS table
> 3. efi_enter_virtual_mode() - Map EFI ranges

Thanks Toshi, it is all clear now.

@Dave: you might want to put Toshi's explanation in the commit message
of your patch so that we know *why* the change is needed.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
