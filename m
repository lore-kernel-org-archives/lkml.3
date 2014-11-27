Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaK0QVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:21:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32547 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaK0QVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:21:34 -0500
Date: Thu, 27 Nov 2014 11:21:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@suse.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org,
        gregkh@linuxfoundation.org, david.vrabel@citrix.com,
        stable@vger.kernel.org, rshendershot@mchsi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141127162118.GA24829@konrad-lan.dumpdata.com>
References: <b4d424e6-81b2-4b21-ab2f-3d403a455f57@default>
 <20141127091228.GA4828@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127091228.GA4828@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 10:12:28AM +0100, Borislav Petkov wrote:
> On Wed, Nov 26, 2014 at 07:13:02PM -0800, Boris Ostrovsky wrote:
> > I was confusing you: accessing dis_ucode_ldr by virtual address does
> > work on PV. But we then fail later, in load_ucode_intel_ap(), because
> > it also tries to use __pa_nodebug() which can't be used by PV.
> >
> > So if accessing dis_ucode_ldr by virtual address is acceptable
> > (although I don't think it is?) then we can stick dis_ucode_ldr=1 into
> > xen_start_kernel() and then things look OK.
> >
> > A better solution may be to replace cpuid in x86_guest() with 'return
> > pv_info.paravirt_enabled' (or paravirt_enabled(), I guess). I gave
> > it a quick spin (32-bit only) and it seems to work. I'll see how my
> > overnight tests behave.
> 
> Ok, but let's have a clean design: maybe have a weak default stub which
> returns false when PARAVIRT is not enabled in the .config and then add
> an override in, say, arch/x86/kernel/paravirt.c which returns true when
> running as a guest. Something like that, at least.

You are describing 'paravirt_enabled()' :-)
> 
> I can imagine other stuff wanting to use the dynamic checking at runtime
> too...
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
