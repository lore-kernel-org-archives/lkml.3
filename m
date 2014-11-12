Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaKLRZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:25:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbaKLRZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:25:21 -0500
Date: Wed, 12 Nov 2014 18:25:13 +0100
From: Borislav Petkov <bp@suse.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
Message-ID: <20141112172513.GC17793@pd.tnic>
References: <5462999A.7090706@intel.com>
 <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com>
 <54637576.7030004@intel.com>
 <20141112151106.GB17793@pd.tnic>
 <54637AD5.6060300@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54637AD5.6060300@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 07:20:53AM -0800, Dave Hansen wrote:
> So perhaps efi_map_region() is handing an address from the EFI identity
> map down in here.  __pa() gets called on it, but that fails since __pa()
> only works on the *KERNEL* identity map.

Grrr, yeah, so pageattr.c assumes the kernel pgd in some places still.

> I think we might actually need to walk the page tables in there.  Even
> the pfn_range_is_mapped() code looks to be dealing with the kernel
> identity map.

Yep, pageattr.c should be taught to pay attention to cpa->pgd. Btw, we
do have lookup_address_in_pgd() there which should do the walking.

But before we do that: Matt, why do we need the kernel text mapped 1:1
in the EFI page table at all?

You've added this with

4f9dbcfc4029 ("x86/efi: Add mixed runtime services support")

AFAICT.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
