Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3LLCQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:16:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab3LLCQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:16:42 -0500
Date: Thu, 12 Dec 2013 10:15:51 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 07/14] efi: export more efi table variable to sysfs
Message-ID: <20131212021551.GE3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-8-git-send-email-dyoung@redhat.com>
 <20131211183203.GF23793@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211183203.GF23793@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 at 07:32pm, Borislav Petkov wrote:
> On Mon, Dec 09, 2013 at 05:42:20PM +0800, Dave Young wrote:
> > Export fw_vendor, runtime and config table physical addresses to
> > /sys/firmware/efi/fw_vendor, /sys/firmware/efi/runtime and
> > /sys/firmware/efi/config_table because kexec kernel will need them.
> 
> you might wanna shorten:
> 
> ... sys/firmware/efi/{fw_vendor,runtime,config_table} ...

Ok, will do.

> 
> > 
> > From EFI spec these 3 variables will be updated to
> > virtual address after entering virtual mode. But
> > kernel startup code will need the physical address.
> > 
> > changelog:
> > Greg: add standalone sysfs files instead of add lines to systab
> > Document them as testing ABI
> > Greg: use group attrs and is_visible
> > Boris: align comments lines
> > Boris: add macros for _show functions
> > Matt: Documentation fixes.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  Documentation/ABI/testing/sysfs-firmware-efi | 24 +++++++++++++++++
> >  arch/x86/platform/efi/efi.c                  |  4 +++
> >  drivers/firmware/efi/efi.c                   | 39 ++++++++++++++++++++++++++++
> >  include/linux/efi.h                          |  3 +++
> >  4 files changed, 70 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
> > new file mode 100644
> > index 0000000..8c6e460
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-firmware-efi
> > @@ -0,0 +1,24 @@
> > +What:		/sys/firmware/efi/fw_vendor
> > +Date:		December 2013
> > +Contact:	Dave Young <dyoung@redhat.com>
> > +Description:
> > +		It shows the physical address of firmware vendor field in the
> 
> Why doesn't this start at the same line as "Description:"?

It can, just in 1st version I copied the format from some template, I have
found it's better so updated the Users line but missed the Description.

Will do in next version.

> 
> > +		EFI system table.
> > +
> 
> Superfluous newline.

Will remove it.

[snip]
> > +
> >  static struct attribute *efi_subsys_attrs[] = {
> >  	&efi_attr_systab.attr,
> > +	&efi_attr_fw_vendor.attr,
> > +	&efi_attr_runtime.attr,
> > +	&efi_attr_config_table.attr,
> >  	NULL,	/* maybe more in the future? */
> 		^^^^^
> 
> Now that there's more, you can drop that wise guy comment :)

Ok.

--
Thanks for review
Dave
