Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab3LFBc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:32:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3LFBcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:32:51 -0500
Date: Fri, 6 Dec 2013 09:31:44 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131206013143.GA3792@dhcp-16-126.nay.redhat.com>
References: <1386023600.1791.201.camel@misato.fc.hp.com>
 <1386034289.1791.210.camel@misato.fc.hp.com>
 <20131203015613.GB3980@dhcp-16-126.nay.redhat.com>
 <1386085140.1791.218.camel@misato.fc.hp.com>
 <20131204024610.GA3764@dhcp-16-126.nay.redhat.com>
 <1386175428.1791.225.camel@misato.fc.hp.com>
 <20131205015615.GC3736@dhcp-16-126.nay.redhat.com>
 <20131205115124.GC14407@pd.tnic>
 <1386258962.1791.268.camel@misato.fc.hp.com>
 <20131205205250.GF14407@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205205250.GF14407@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/13 at 09:52pm, Borislav Petkov wrote:
> On Thu, Dec 05, 2013 at 08:56:02AM -0700, Toshi Kani wrote:
> > The smbios in efi_setup_data is necessary for kexec to pass the physical
> > address of the SMBIOS table from the 1st kernel to the 2nd kernel.
> > 
> > The kernel boot sequence proceeds in the following order.  Step 2
> > requires efi.smbios to be the physical address.  However, Dave found
> > that EFI system table has a virtual address of SMBIOS in step 1.  Hence,
> > he sets it back to the physical address with the smbios in
> > efi_setup_data.  (When it is still the physical address, it simply sets
> > the same value.)
> > 
> > 1. efi_init() - Set efi.smbios from EFI system table
> > 2. dmi_scan_machine() - Temporary map efi.smbios to access SMBIOS table
> > 3. efi_enter_virtual_mode() - Map EFI ranges
> 
> Thanks Toshi, it is all clear now.
> 
> @Dave: you might want to put Toshi's explanation in the commit message
> of your patch so that we know *why* the change is needed.

Ok, will do.

Thanks
Dave
