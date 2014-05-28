Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaE1CMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaE1CMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:12:37 -0400
Date: Wed, 28 May 2014 10:13:59 +0800
From: Dave Young <dyoung@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140528021359.GC2820@darkstar.nay.redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527133411.GG10994@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527133411.GG10994@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/14 at 09:34am, Vivek Goyal wrote:
> On Mon, May 26, 2014 at 04:39:35PM +0800, Dave Young wrote:
> > 
> > For efi=old_map and any old_map quirks like SGI UV in current
> > tree kexec/kdump will fail because it depends on the new 1:1 mapping.
> > 
> > Thus export the mapping method to sysfs so kexec tools can switch
> > to original way to boot.
> > 
> > Since we have efi.flags for all efi facilities so let's just export the
> > efi.flags itself, it maybe useful for other arches and use cases.
> > 
> 
> Does it require any documentation in Documentation/ABI/..

Yes, it's necessary. Will do in next version.

I'm still discussing with Matt, exporting efi.flags seems not a good way
because they are more internal interfaces. 

Probably I should export only a file 'old_map' instead.

> 
> Vivek
> 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  drivers/firmware/efi/efi.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux-2.6/drivers/firmware/efi/efi.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/firmware/efi/efi.c
> > +++ linux-2.6/drivers/firmware/efi/efi.c
> > @@ -86,16 +86,19 @@ static ssize_t name##_show(struct kobjec
> >  EFI_ATTR_SHOW(fw_vendor);
> >  EFI_ATTR_SHOW(runtime);
> >  EFI_ATTR_SHOW(config_table);
> > +EFI_ATTR_SHOW(flags);
> >  
> >  static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
> >  static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
> >  static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
> > +static struct kobj_attribute efi_attr_flags = __ATTR_RO(flags);
> >  
> >  static struct attribute *efi_subsys_attrs[] = {
> >  	&efi_attr_systab.attr,
> >  	&efi_attr_fw_vendor.attr,
> >  	&efi_attr_runtime.attr,
> >  	&efi_attr_config_table.attr,
> > +	&efi_attr_flags.attr,
> >  	NULL,
> >  };
> >  
