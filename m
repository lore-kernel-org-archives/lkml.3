Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbaKMNKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:10:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:3415 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932864AbaKMNKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:10:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,377,1413270000"; 
   d="scan'208";a="636355456"
Message-ID: <1415884083.14686.439.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
From: Matt Fleming <matt.fleming@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Borislav Petkov <bp@suse.de>, the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 13:08:03 +0000
In-Reply-To: <54637AD5.6060300@intel.com>
References: <5462999A.7090706@intel.com>
	 <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com>
	 <54637576.7030004@intel.com> <20141112151106.GB17793@pd.tnic>
	 <54637AD5.6060300@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 07:20 -0800, Dave Hansen wrote:
> 
> The path that we're actually hitting this from is:
> 
> > __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long
> ...
> >         if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
> >                                 PFN_DOWN(__pa(address)) + 1))
> >                 split_page_count(level);

I'm sure I'm just being dumb, but I can't for the life of me work out
why we need to calculate the physical address from the virtual address
at this point - we should already have that information.

> So perhaps efi_map_region() is handing an address from the EFI identity
> map down in here.  __pa() gets called on it, but that fails since __pa()
> only works on the *KERNEL* identity map.

Yep, sounds right.

