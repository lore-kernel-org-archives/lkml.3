Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3LQGOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:14:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab3LQGOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:14:47 -0500
Date: Tue, 17 Dec 2013 14:13:47 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v6 08/14] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131217061347.GD6751@dhcp-16-126.nay.redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-9-git-send-email-dyoung@redhat.com>
 <20131216150929.GA3873@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216150929.GA3873@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/13 at 03:09pm, Matt Fleming wrote:
> On Mon, 16 Dec, at 05:30:29PM, Dave Young wrote:
> > @@ -899,6 +928,11 @@ void __init efi_enter_virtual_mode(void)
> >  		return;
> >  	}
> >  
> > +#ifdef CONFIG_EFI_RUNTIME_MAP
> > +	efi_runtime_map_setup(efi_runtime_map, nr_efi_runtime_map,
> > +			      boot_params.efi_info.efi_memdesc_size);
> > +#endif
> 
> [...]
> 
> > @@ -167,6 +167,12 @@ static int __init efisubsys_init(void)
> >  		goto err_unregister;
> >  	}
> >  
> > +#ifdef CONFIG_EFI_RUNTIME_MAP
> > +	error = efi_runtime_map_init(efi_kobj);
> > +	if (error)
> > +		goto err_remove_group;
> > +#endif
> 
> [...]
> 
> > @@ -876,4 +876,9 @@ int efivars_sysfs_init(void);
> >  
> >  #endif /* CONFIG_EFI_VARS */
> >  
> > +#ifdef CONFIG_EFI_RUNTIME_MAP
> > +int efi_runtime_map_init(struct kobject *);
> > +void efi_runtime_map_setup(void *, int, u32);
> > +#endif
> 
> I was thinking more along the lines of...

Previously I only call the function conditionally thus there's
compiler warning about "unused function" for the #else

unconditionally call it build will be ok. Will update this patch.
