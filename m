Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3JWMwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:52:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3JWMv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:51:58 -0400
Date: Wed, 23 Oct 2013 20:51:31 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131023125131.GA5552@dhcp-16-126.nay.redhat.com>
References: <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
 <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
 <20131021133741.GA5716@nazgul.tnic>
 <20131021150426.GB4515@dhcp-16-126.nay.redhat.com>
 <20131022111857.GA10660@nazgul.tnic>
 <20131023021730.GE4594@dhcp-16-126.nay.redhat.com>
 <20131023122531.GA15848@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023122531.GA15848@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/13 at 02:25pm, Borislav Petkov wrote:
> On Wed, Oct 23, 2013 at 10:17:31AM +0800, Dave Young wrote:
> > The reason is that I only pass runtime regions from 1st kernel to
> > kexec kernel, your efi mapping function uses the region size to
> > determin the virtual address from top to down. Because the passed-in
> > md ranges in kexec kernel are different from ranges booting from
> > firmware so the virtual address will be different.
> 
> Well, this shouldn't be because SetVirtualAddressMap has already fixed
> the virtual addresses for us. And if they're different, then runtime
> services won't work anyway. Or am I missing something...?

Maybe I did not explain clear enough.
Say first kernel mapping below regions:
Region A (boot service):phys_start_a size_a -> virt_start_a size_a
Region B (runtime):	phys_start_b size_b -> virt_start_b size_b

I will pass Range B into 2nd kernel
(phys_start_b, size_b, virt_start_b)

In kexed 2nd kernel, phys_start_b need to be mapped to virt_start_b
Simply use efi_map_region from your patch does not work because it
will map phys_start_b to a different virt address, isn't it?

So I need simply map according to the kexec passed in mapping addr.

Thanks
Dave
