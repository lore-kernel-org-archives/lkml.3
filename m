Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaFEPBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:01:54 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54601 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaFEPBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:01:52 -0400
Date: Thu, 5 Jun 2014 16:01:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/efi: Only pass mapped RAM regions to
 free_bootmem_late()
Message-ID: <20140605160102.3c58481e@www.etchedpixels.co.uk>
In-Reply-To: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
References: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Jun 2014 14:27:34 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> From: Matt Fleming <matt.fleming@intel.com>
> 
> free_bootmem_late() expects to only be passed RAM regions that the
> kernel can access, and that have a corresponding 'struct page'. It's
> possible for regions in the EFI memory map to reside in address ranges
> for which pfn_to_page() doesn't work, for instance when running on an
> i386 system with CONFIG_HIGHMEM=n.
> 
> This is in fact the case for one of Alan's machines where some of the
> EFI boot services pages live in highmem, and running a kernel without
> CONFIG_HIGHMEM enabled results in the following oops,
> 
>  BUG: unable to handle kernel paging request at f7f1f080
>  IP: [<c17fba96>] __free_pages_bootmem+0x5a/0xb8
>  *pdpt = 0000000001887001 *pde = 0000000001984067 *pte = 000000000 0000000
>  Oops: 0002 [#1] SMP

No improvement, and the if case is never true 8(

