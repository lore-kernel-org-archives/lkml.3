Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaESUrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:47:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42408 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaESUrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:47:45 -0400
Date: Mon, 19 May 2014 22:46:57 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org,
        matt.fleming@intel.com, x86@kernel.org, tglx@linutronix.de,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, eshelton@pobox.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Message-ID: <20140519204657.GB3529@olila.local.net-space.pl>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
 <537A23A50200007800013A7F@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537A23A50200007800013A7F@mail.emea.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 02:30:45PM +0100, Jan Beulich wrote:
> >>> On 16.05.14 at 22:41, <daniel.kiper@oracle.com> wrote:
> > @@ -457,6 +460,21 @@ void __init efi_free_boot_services(void)
> >  	efi_unmap_memmap();
> >  }
> >
> > +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
> > +							unsigned long size)
> > +{
> > +	if (efi_enabled(EFI_DIRECT))
> > +		return early_ioremap(phys_addr, size);
> > +
> > +	return (__force void __iomem *)phys_addr;
>
> Now that surely needs some explanation: I can't see how this can
> ever be correct, Xen or not being completely irrelevant.

I hope that efi_enabled(EFI_DIRECT) is obvious. However, in case of
!efi_enabled(EFI_DIRECT) some structures are created artificially
and they live in virtual address space. So that is why they should
not be mapped. If you wish I could add relevant comment here.

Daniel
