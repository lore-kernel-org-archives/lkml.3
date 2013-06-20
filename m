Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161217Ab3FTSrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:47:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42087 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161195Ab3FTSrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:47:46 -0400
Date: Thu, 20 Jun 2013 20:47:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130620184736.GC19877@pd.tnic>
References: <1371740019.2372.3.camel@dabdike>
 <20130620162916.GA25727@srcf.ucam.org>
 <1371746775.2372.11.camel@dabdike>
 <20130620165426.GB26214@srcf.ucam.org>
 <20130620170124.GA19877@pd.tnic>
 <20130620171210.GA26593@srcf.ucam.org>
 <20130620180808.GB19877@pd.tnic>
 <20130620181015.GA27833@srcf.ucam.org>
 <20130620181445.GA791@pd.tnic>
 <20130620181731.GA27960@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130620181731.GA27960@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 07:17:31PM +0100, Matthew Garrett wrote:
> On Thu, Jun 20, 2013 at 08:14:45PM +0200, Borislav Petkov wrote:
> > On Thu, Jun 20, 2013 at 07:10:15PM +0100, Matthew Garrett wrote:
> > > Because Windows passes high addresses to SetVirtualAddressMap(), and
> > > because if you can imagine firmware developers getting it wrong then
> > > firmware developers will have got it wrong.
> > 
> > Can we reversely assume that if we'd used fixed high offsets, as hpa
> > suggests, then it'll be fine? IOW, are any high addresses, even fixed
> > ones, fine?
> 
> Windows actually seems to start at the top of address space and go down 
> - this is what I get booting Windows 8 under kvm. It looks like very 
> high addresses are fine, and we're currently using "low" high addresses, 
> so I suspect we're fine pretty much anywhere in that range.
> 
> ****** SetVirtualAddressMap
> Type: 5
> Physical Start: 3E878000
> Virtual Start: FFFFFFFFFFBEB000
> Number Of Pages: 15
> Attributes: 800000000000000F
> Type: 6
> Physical Start: 3E88D000
> Virtual Start: FFFFFFFFFFBD6000
> Number Of Pages: 15
> Attributes: 800000000000000F
> Type: 5
> Physical Start: 3FB22000
> Virtual Start: FFFFFFFFFFBA6000
> Number Of Pages: 30
> Attributes: 800000000000000F
> Type: 6
> Physical Start: 3FB52000
> Virtual Start: FFFFFFFFFFB82000
> Number Of Pages: 24
> Attributes: 800000000000000F
> Type: 6
> Physical Start: 3FFE0000
> Virtual Start: FFFFFFFFFFB62000
> Number Of Pages: 20

I guess we can do a top-down allocation, starting from the highest
virtual addresses:

EFI_HIGHEST_ADDRESS
|
| size1
|
--> region1
|
| size2
|
--> region2

...

and we make EFI_HIGHEST_ADDRESS be the same absolute number on every
system.

hpa, is this close to what you had in mind? It would be prudent to
verify whether this will suit well with the kexec virtual space layout
though...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
