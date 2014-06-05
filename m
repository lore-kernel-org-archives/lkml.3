Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaFESHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:07:54 -0400
Received: from mail-wg0-f68.google.com ([74.125.82.68]:58550 "EHLO
	mail-wg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaFESHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:07:52 -0400
MIME-Version: 1.0
X-Originating-IP: [90.207.204.193]
In-Reply-To: <20140605160102.3c58481e@www.etchedpixels.co.uk>
References: <1401974854-7716-1-git-send-email-matt@console-pimps.org>
	<20140605160102.3c58481e@www.etchedpixels.co.uk>
Date: Thu, 5 Jun 2014 19:07:50 +0100
Message-ID: <CADknwL7t3phPTnr6YFUduVVJ_=qaN3uWexhQ3LWj71U5Mh-zjA@mail.gmail.com>
Subject: Re: [PATCH] x86/efi: Only pass mapped RAM regions to free_bootmem_late()
From: Matt Fleming <matt@console-pimps.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2014 16:01, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu,  5 Jun 2014 14:27:34 +0100
> Matt Fleming <matt@console-pimps.org> wrote:
>
>> From: Matt Fleming <matt.fleming@intel.com>
>>
>> free_bootmem_late() expects to only be passed RAM regions that the
>> kernel can access, and that have a corresponding 'struct page'. It's
>> possible for regions in the EFI memory map to reside in address ranges
>> for which pfn_to_page() doesn't work, for instance when running on an
>> i386 system with CONFIG_HIGHMEM=n.
>>
>> This is in fact the case for one of Alan's machines where some of the
>> EFI boot services pages live in highmem, and running a kernel without
>> CONFIG_HIGHMEM enabled results in the following oops,
>>
>>  BUG: unable to handle kernel paging request at f7f1f080
>>  IP: [<c17fba96>] __free_pages_bootmem+0x5a/0xb8
>>  *pdpt = 0000000001887001 *pde = 0000000001984067 *pte = 000000000 0000000
>>  Oops: 0002 [#1] SMP
>
> No improvement, and the if case is never true 8(

Argh, dammit. OK, back to the drawing board. Thanks for testing.
