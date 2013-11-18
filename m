Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3KRCLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:11:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3KRCLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:11:10 -0500
Date: Mon, 18 Nov 2013 10:09:39 +0800
From: Dave Young <dyoung@redhat.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 1/7 v2] Add function efi_remap_region for remapping to
 saved virt address
Message-ID: <20131118020939.GB4025@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082715.502723229@dhcp-16-126.nay.redhat.com>
 <1384556525.1791.4.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384556525.1791.4.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/13 at 04:02pm, Toshi Kani wrote:
> On Tue, 2013-11-05 at 16:20 +0800, dyoung@redhat.com wrote:
> > Kexec kernel will use saved runtime virtual mapping, so add a
> > new function efi_remap_region to remapping it directly without
> > calculate the virt addr from efi_va.
> > 
> > The md is passed in from 1st kernel, the virtual addr is
> > saved in md->virt_addr.
> 
>  :
> 
> > +/*
> > + * kexec kernel will use efi_map_region_fixed to map efi
> > + * runtime memory ranges. md->virt_addr is the original virtual
> > + * address which had been mapped in kexec 1st kernel.
> > + */
> > +void __init efi_map_region_fixed(efi_memory_desc_t *md)
> 
> Can you simply use __map_region() instead of creating this function?
> Both functions seem to do the same thing.  (In __map_region(), size and
> end are not used.)

Matt also suggest to reuse __map_region in another apply, will do.

--
Thanks for review
Dave
