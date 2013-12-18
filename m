Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3LRJIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:08:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab3LRJI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:08:26 -0500
Date: Wed, 18 Dec 2013 17:07:57 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Message-ID: <20131218090757.GA15594@dhcp-16-126.nay.redhat.com>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387236997-26975-4-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/13 at 12:36am, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Currently, running SetVirtualAddressMap() and passing the physical
> address of the virtual map array was working only by a lucky coincidence
> because the memory was present in the EFI page table too. Until Toshi
> went and booted this on a big HP box - the krealloc() manner of resizing
> the memmap we're doing did allocate from such physical addresses which
> were not mapped anymore and boom:
> 
> http://lkml.kernel.org/r/1386806463.1791.295.camel@misato.fc.hp.com
> 
> One way to take care of that issue is to reimplement the krealloc thing
> but with pages. We start with contiguous pages of order 1, i.e. 2 pages,
> and when we deplete that memory (shouldn't happen all that often but you
> know firmware) we realloc the next power-of-two pages.

How about firstly count the md numbers in the 1st loop, then get/roundup
the total size, alloc the pages, map the mds one by one in another loop.

Thanks
Dave
