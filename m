Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3IUP7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:59:14 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41746 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3IUP7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:59:12 -0400
Date: Sat, 21 Sep 2013 17:59:15 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, Mark Salter <msalter@redhat.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, Roy Franz <roy.franz@linaro.org>
Subject: Re: [PATCH 02/11] efi: Remove EFI_PAGE_SHIFT and EFI_PAGE_SIZE
Message-ID: <20130921155914.GH2737@rocoto.smurfnet.nu>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-3-git-send-email-bp@alien8.de>
 <20130920104249.GA21381@console-pimps.org>
 <20130921152139.GG2737@rocoto.smurfnet.nu>
 <20130921154143.GC1587@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130921154143.GC1587@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 05:41:43PM +0200, Borislav Petkov wrote:
> On Sat, Sep 21, 2013 at 05:21:39PM +0200, Leif Lindholm wrote:
> 
> > It will probably not be a problem on the stub side, and it's not used
> > in many places but it would break efi_lookup_mapped_address(),
> > efi_range_is_wc() and memrange_efi_to_native() for use by arm64.
> > At least the first of these would be a problem.
> 
> Ok, maybe the generic header include/linux/efi.h might be a problem but
> the rest are changes to arch/x86/ which should have no effect whatsoever
> on any other arch.

Indeed - my concerns are restricted to include/linux/efi.h and
drivers/firmware/efi.c.

> Or are you planning to move some of it into generic code?

I think some of the stub code is moved to generic in Roy's/Mark's
patches - but then the stub shouldn't be an issue as in UEFI we have
4K pages.

/
    Leif
