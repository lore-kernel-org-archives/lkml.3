Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab3FTJWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:22:45 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51618 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab3FTJWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:22:41 -0400
Date: Thu, 20 Jun 2013 11:22:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130620092237.GA6943@gmail.com>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130620091321.GB6811@gmail.com>
 <20130620091537.GA17159@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620091537.GA17159@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Jun 20, 2013 at 11:13:21AM +0200, Ingo Molnar wrote:
> 
> > Cool - and supposedly this will work in a Mac environment as well? Would 
> > be very nice to avoid fundamentally fragile system specific quirks for 
> > something as fundamental as the EFI runtime memory mapping model ...
> 
> Apple is the only case where I'd expect there to be an issue, since they 
> only started supporting booting Windows via UEFI on very recent systems. 
> However, unless they're actually sniffing the page tables on UEFI entry, 
> I can't see any way that this could break things???

Agreed - I was susprised to see that the runtime was able to _break_ in 
any way due to 1:1: my assumption was that it can only get better.

But I did not realize that the 1:1 boot flag also changed what was passed 
down, which probably explains the breakages.

I'd even argue to not do this whole boot flag thing at all - just 
standardize on the Windows compatibility model as closely as possible.

Thanks,

	Ingo
