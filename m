Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3FFNaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:30:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37246 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab3FFNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:30:28 -0400
Date: Thu, 6 Jun 2013 14:30:23 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 2/4] x86, cpa: Map in an arbitrary pgd
Message-ID: <20130606133023.GJ30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-3-git-send-email-bp@alien8.de>
 <20130606102233.GG30420@console-pimps.org>
 <20130606132406.GC20972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606132406.GC20972@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun, at 03:24:06PM, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 11:22:33AM +0100, Matt Fleming wrote:
> > > @@ -697,7 +714,10 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
> > >  	else
> > >  		address = *cpa->vaddr;
> > >  repeat:
> > > -	kpte = lookup_address(address, &level);
> > > +	if (cpa->pgd)
> > > +		kpte = __lookup_address_in_pgd(cpa->pgd, address, &level);
> > > +	else
> > > +		kpte = _lookup_address_cpa(cpa, address, &level);
> > 
> > Don't you also need to initialise .pgd in __set_pages_p() and
> > __set_pages_np()?
> 
> Hmm, I don't think so. The idea is to leave the current functionality in
> pageattr.c untouched. Currently, it maps PTEs in init_mm.pgd by default
> because this is the kernel PGD.

I meant because the .pgd member is uninitialised and contains garbage.

-- 
Matt Fleming, Intel Open Source Technology Center
