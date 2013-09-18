Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3IRBho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3IRBhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:37:42 -0400
Date: Wed, 18 Sep 2013 09:37:34 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH] EFI: use nr_tables param directly in efi_config_init
Message-ID: <20130918013734.GA31668@dhcp-16-126.nay.redhat.com>
References: <20130912084528.GA13448@dhcp-16-126.nay.redhat.com>
 <20130917154921.GH3409@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917154921.GH3409@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/13 at 04:49pm, Matt Fleming wrote:
> On Thu, 12 Sep, at 04:45:28PM, Dave Young wrote:
> > efi_config_init has the parameter nr_tables. Just use it instead of
> > dereference efi.systab->nr_tables.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/platform/efi/efi.c |    7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > --- linux-2.6.orig/arch/x86/platform/efi/efi.c
> > +++ linux-2.6/arch/x86/platform/efi/efi.c
> > @@ -599,7 +599,7 @@ static int __init efi_config_init(u64 ta
> >  
> >  	tablep = config_tables;
> >  	pr_info("");
> > -	for (i = 0; i < efi.systab->nr_tables; i++) {
> > +	for (i = 0; i < nr_tables; i++) {
> >  		efi_guid_t guid;
> >  		unsigned long table;
> >  
> > @@ -612,8 +612,7 @@ static int __init efi_config_init(u64 ta
> >  			if (table64 >> 32) {
> >  				pr_cont("\n");
> >  				pr_err("Table located above 4GB, disabling EFI.\n");
> > -				early_iounmap(config_tables,
> > -					      efi.systab->nr_tables * sz);
> > +				early_iounmap(config_tables, nr_tables * sz);
> >  				return -EINVAL;
> >  			}
> >  #endif
> > @@ -648,7 +647,7 @@ static int __init efi_config_init(u64 ta
> >  		tablep += sz;
> >  	}
> >  	pr_cont("\n");
> > -	early_iounmap(config_tables, efi.systab->nr_tables * sz);
> > +	early_iounmap(config_tables, nr_tables * sz);
> >  	return 0;
> >  }
> 
> Thanks Dave, but this patch should no longer be necessary because of the
> changes sitting in the 'next' branch at,
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

Ok, no problem. Thanks for letting me know.

Will write patches based on the above tree next time.

> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
