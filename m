Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3K2Jrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:47:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab3K2Jrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:47:36 -0500
Date: Fri, 29 Nov 2013 17:46:52 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131129094652.GK4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
 <20131126220448.GB18170@console-pimps.org>
 <20131127045237.GC11852@dhcp-16-126.nay.redhat.com>
 <20131127101747.GC18170@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127101747.GC18170@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/13 at 10:17am, Matt Fleming wrote:
> On Wed, 27 Nov, at 12:52:37PM, Dave Young wrote:
> > To make it more readable, I will change them like below:
> > 
> > p = efi_runtime_map;
> > md = efi_setup->map;
> > for (i = 0; i < nr_efi_runtime_map; i++) {
> > 	[...]
> > 	md += 1;
> > }
>  
> Actually, md++ is the canonical way to write this.

Ok.

> 
> > > 
> > > > +		efi_map_region_fixed(md);
> > > > +		size = md->num_pages << PAGE_SHIFT;
> > > > +		end = md->phys_addr + size;
> > > > +
> > > > +		systab = (u64) (unsigned long) efi_phys.systab;
> > > > +		if (md->phys_addr <= systab && systab < end) {
> > > > +			systab += md->virt_addr - md->phys_addr;
> > > > +			efi.systab =
> > > > +				(efi_system_table_t *) (unsigned long) systab;
> > > > +		}
> > > > +		if (efi_runtime_map) {
> > > > +			memcpy(p, md, memmap.desc_size);
> > > > +			p += memmap.desc_size;
> > > > +		}
> > > 
> > > Is this if () needed? Is it possible to enter the loop and have
> > > 'efi_runtime_map' be NULL?
> > 
> > Yes, it is needed. if efi_runtime_map kmalloc fails I only print error, do not
> > return so kernel can still boot, just kexec on efi will not work that has been
> > put in the error message.
>  
> OK. On second thought, is there any way to turn the above code into a
> call to efi_save_runtime_map()? Because you've basically duplicated that
> code and I can definitely envisage the two code paths fragmenting over
> time, e.g. when someone makes changes to one but not the other.

OK, will consider to reuse the function.

Thanks
Dave
