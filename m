Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3J1MEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:04:07 -0400
Received: from mout.gmx.net ([212.227.17.21]:54372 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683Ab3J1MEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:04:04 -0400
Date: Mon, 28 Oct 2013 13:03:58 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028120358.GE2278@thinkpad.fritz.box>
References: <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028103428.GA2278@thinkpad.fritz.box>
 <20131028105731.GF4314@pd.tnic>
 <20131028112505.GD2278@thinkpad.fritz.box>
 <20131028114541.GI4314@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131028114541.GI4314@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:2JPYFRau6YqDLk3PbDNcAPWRHUVKYRApnETuPD0vf247cUtvf4L
 nOszWhv0pf6vypW6R4xm/YJ8/CBlJ44j8RRdtCESZB+zycvwZoehAqr5amjB/o9eFi+AP9W
 XW/LuDpXwsoeXLVT3PH4ocDbaX3+nMjnl4yeOaIupCUXy6NyZBgVGNtnai3ecOihlgE9iXR
 ZhpUYDDhMBzmXcPBZhcrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 12:45:41PM +0100, Borislav Petkov wrote:
> Drop Dave's stale mail address.
> 
> On Mon, Oct 28, 2013 at 12:25:05PM +0100, Andreas Werner wrote:
> > > but you end up doing
> > > 
> > >   PAT=Write-Back + MTRR=Write-Through = Effective Memory of Write-Back
> > >
> > No the effective memory type is WT, check out the Intel document with the
> > table of Effective memory type combinations.
> 
> You need to read what I'm saying more carefully.
Sorry then i missunderstood something?
> 
> > Yes but, there is no way in the kernel to mark a memory WT,
> 
> That doesn't mean you can return _PAGE_CACHE_WB for MTRR_TYPE_WRTHROUGH.
> The correct thing to do, IMHO, would be to set the PWT bit in the PTEs
> of those pages comprising your buffer.
> 
But why? the combination of PAT=WB and MTRR=WT is allowed isn´t it?
What should i return instead of?

regards
Andy
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
