Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3K0CzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:55:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758352Ab3K0CzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:55:15 -0500
Date: Wed, 27 Nov 2013 10:53:45 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 05/12] efi: export more efi table variable to sysfs
Message-ID: <20131127025345.GA11852@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-6-git-send-email-dyoung@redhat.com>
 <20131126155731.GM11521@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126155731.GM11521@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/13 at 03:57pm, Matt Fleming wrote:
> On Tue, 26 Nov, at 01:57:50PM, Dave Young wrote:
> > Export fw_vendor, runtime and config tables physical
> > addresses to /sys/firmware/efi/systab becaue kexec
> > kernel will need them.
>  
> This commit log needs updating.

Will update

> 
> > From EFI spec these 3 variables will be updated to
> > virtual address after entering virtual mode. But
> > kernel startup code will need the physical address.
> > 
> > changelog:
> > Greg: add standalone sysfs files instead of add lines to systab
> > Document them as testing ABI
> > Greg: use group attrs and is_visible
> > Boris: align comments lines
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  Documentation/ABI/testing/sysfs-firmware-efi | 26 ++++++++++++++++
> >  arch/x86/platform/efi/efi.c                  |  4 +++
> >  drivers/firmware/efi/efi.c                   | 44 ++++++++++++++++++++++++++++
> >  include/linux/efi.h                          |  3 ++
> >  4 files changed, 77 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
> > new file mode 100644
> > index 0000000..9252a24
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-firmware-efi
> > @@ -0,0 +1,26 @@
> > +What:		/sys/firmware/efi/fw_vendor
> > +Date:		Nov 2013
> > +Contact:	Dave Young <dyoung@redhat.org>
> 
> redhat.org eh? Typo or legit?

It's typo, will fix

> 
> > +Description:
> > +		Shows the physical address of firmware vendor in the EFI
> > +		system table.
> 
> It shows the physical address of the firmware vendor "entry" or "field"
> in the EFI system table.

Will update

> 
> > +Users:
> > +		Kexec Mailing List <kexec@lists.infradead.org>
> 
> The "Kexec mailing list" isn't a user, kexec is.

Ok, will change to "Kexec"

Thanks for review
Dave
