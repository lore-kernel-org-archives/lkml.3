Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab3FTSRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:17:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58295 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab3FTSRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:17:37 -0400
Date: Thu, 20 Jun 2013 19:17:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130620181731.GA27960@srcf.ucam.org>
References: <20130620094446.GA17882@srcf.ucam.org>
 <1371740019.2372.3.camel@dabdike>
 <20130620162916.GA25727@srcf.ucam.org>
 <1371746775.2372.11.camel@dabdike>
 <20130620165426.GB26214@srcf.ucam.org>
 <20130620170124.GA19877@pd.tnic>
 <20130620171210.GA26593@srcf.ucam.org>
 <20130620180808.GB19877@pd.tnic>
 <20130620181015.GA27833@srcf.ucam.org>
 <20130620181445.GA791@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620181445.GA791@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 08:14:45PM +0200, Borislav Petkov wrote:
> On Thu, Jun 20, 2013 at 07:10:15PM +0100, Matthew Garrett wrote:
> > Because Windows passes high addresses to SetVirtualAddressMap(), and
> > because if you can imagine firmware developers getting it wrong then
> > firmware developers will have got it wrong.
> 
> Can we reversely assume that if we'd used fixed high offsets, as hpa
> suggests, then it'll be fine? IOW, are any high addresses, even fixed
> ones, fine?

Windows actually seems to start at the top of address space and go down 
- this is what I get booting Windows 8 under kvm. It looks like very 
high addresses are fine, and we're currently using "low" high addresses, 
so I suspect we're fine pretty much anywhere in that range.

****** SetVirtualAddressMap
Type: 5
Physical Start: 3E878000
Virtual Start: FFFFFFFFFFBEB000
Number Of Pages: 15
Attributes: 800000000000000F
Type: 6
Physical Start: 3E88D000
Virtual Start: FFFFFFFFFFBD6000
Number Of Pages: 15
Attributes: 800000000000000F
Type: 5
Physical Start: 3FB22000
Virtual Start: FFFFFFFFFFBA6000
Number Of Pages: 30
Attributes: 800000000000000F
Type: 6
Physical Start: 3FB52000
Virtual Start: FFFFFFFFFFB82000
Number Of Pages: 24
Attributes: 800000000000000F
Type: 6
Physical Start: 3FFE0000
Virtual Start: FFFFFFFFFFB62000
Number Of Pages: 20


-- 
Matthew Garrett | mjg59@srcf.ucam.org
