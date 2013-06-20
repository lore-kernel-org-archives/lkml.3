Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab3FTJdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:33:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51163 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965230Ab3FTJdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:33:46 -0400
Date: Thu, 20 Jun 2013 11:33:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130620093337.GI32694@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130620091321.GB6811@gmail.com>
 <20130620091537.GA17159@srcf.ucam.org>
 <20130620092237.GA6943@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130620092237.GA6943@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 11:22:37AM +0200, Ingo Molnar wrote:
> > > Cool - and supposedly this will work in a Mac environment as well? Would 
> > > be very nice to avoid fundamentally fragile system specific quirks for 
> > > something as fundamental as the EFI runtime memory mapping model ...
> > 
> > Apple is the only case where I'd expect there to be an issue, since they 
> > only started supporting booting Windows via UEFI on very recent systems. 
> > However, unless they're actually sniffing the page tables on UEFI entry, 
> > I can't see any way that this could break things???
> 
> Agreed - I was susprised to see that the runtime was able to _break_ in 
> any way due to 1:1: my assumption was that it can only get better.
> 
> But I did not realize that the 1:1 boot flag also changed what was passed 
> down, which probably explains the breakages.

Right, in the next version, the boot flag will influence only what's
being passed down.

> I'd even argue to not do this whole boot flag thing at all - just 
> standardize on the Windows compatibility model as closely as possible.

This will break the Macs so maybe we can do

efi=no_11_map

so the Macs can still boot but use the 1:1 map by default.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
