Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaE0C7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 22:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaE0C7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 22:59:46 -0400
Date: Tue, 27 May 2014 11:00:58 +0800
From: Dave Young <dyoung@redhat.com>
To: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140527030058.GB2372@darkstar.nay.redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/14 at 04:39pm, Dave Young wrote:
> 
> For efi=old_map and any old_map quirks like SGI UV in current
> tree kexec/kdump will fail because it depends on the new 1:1 mapping.
> 
> Thus export the mapping method to sysfs so kexec tools can switch
> to original way to boot.
> 
> Since we have efi.flags for all efi facilities so let's just export the
> efi.flags itself, it maybe useful for other arches and use cases.

Rethink about this issue, export flags will expose the efi facility
macros to userspace, Matt, what's your opinion? It might be better to export
a file 'old_map' only which is '0|1' 

> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  drivers/firmware/efi/efi.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/drivers/firmware/efi/efi.c
> ===================================================================
> --- linux-2.6.orig/drivers/firmware/efi/efi.c
> +++ linux-2.6/drivers/firmware/efi/efi.c
> @@ -86,16 +86,19 @@ static ssize_t name##_show(struct kobjec
>  EFI_ATTR_SHOW(fw_vendor);
>  EFI_ATTR_SHOW(runtime);
>  EFI_ATTR_SHOW(config_table);
> +EFI_ATTR_SHOW(flags);
>  
>  static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
>  static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
>  static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
> +static struct kobj_attribute efi_attr_flags = __ATTR_RO(flags);
>  
>  static struct attribute *efi_subsys_attrs[] = {
>  	&efi_attr_systab.attr,
>  	&efi_attr_fw_vendor.attr,
>  	&efi_attr_runtime.attr,
>  	&efi_attr_config_table.attr,
> +	&efi_attr_flags.attr,
>  	NULL,
>  };
>  
