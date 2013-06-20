Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab3FTSK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:10:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58213 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473Ab3FTSKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:10:22 -0400
Date: Thu, 20 Jun 2013 19:10:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130620181015.GA27833@srcf.ucam.org>
References: <20130620092237.GA6943@gmail.com>
 <20130620093337.GI32694@pd.tnic>
 <20130620094446.GA17882@srcf.ucam.org>
 <1371740019.2372.3.camel@dabdike>
 <20130620162916.GA25727@srcf.ucam.org>
 <1371746775.2372.11.camel@dabdike>
 <20130620165426.GB26214@srcf.ucam.org>
 <20130620170124.GA19877@pd.tnic>
 <20130620171210.GA26593@srcf.ucam.org>
 <20130620180808.GB19877@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620180808.GB19877@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 08:08:08PM +0200, Borislav Petkov wrote:
> On Thu, Jun 20, 2013 at 06:12:10PM +0100, Matthew Garrett wrote:
> > On Thu, Jun 20, 2013 at 07:01:24PM +0200, Borislav Petkov wrote:
> > 
> > > If we can detect the Macs, we can make this decision automatic. And
> > > since no Mac boots windoze, a single DMI check of the sort "if (Mac)"
> > > should suffice.
> > 
> > Yes, we can special-case Macs. But since our behaviour is then obviously 
> > different to Windows, we'll inevitably break some other system.
> 
> Why different? We'll have the high mappings and shove the 1:1 mappings
> down SetVirtualAddressMap by default.

Because Windows passes high addresses to SetVirtualAddressMap(), and 
because if you can imagine firmware developers getting it wrong then 
firmware developers will have got it wrong.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
