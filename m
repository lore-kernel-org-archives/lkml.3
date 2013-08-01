Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3HAQvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:51:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37493 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3HAQvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:51:52 -0400
Date: Thu, 1 Aug 2013 18:51:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Corrupted EFI region
Message-ID: <20130801165150.GB7445@pd.tnic>
References: <20130731205431.GG4724@pd.tnic>
 <20130731205858.GA1678@srcf.ucam.org>
 <20130731215130.GA6087@pd.tnic>
 <20130731215423.GA2628@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130731215423.GA2628@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:54:23PM +0100, Matthew Garrett wrote:
> On Wed, Jul 31, 2013 at 11:51:30PM +0200, Borislav Petkov wrote:
> 
> > But the problem is, something messes up the upper boundary of the region
> > and it is an EFI_BOOT_SERVICES_DATA region which we need for the runtime
> > services mapping and if we can't map it properly, we're probably going
> > to miss functionality or not have runtime at all.
> 
> "Easiest" way around this would probably be to stash the address map
> after ExitBootServices() and compare it at SetVirtualAddressMap()
> time, then take the widest boundaries and trim the e820 map to match.
> This is obviously dependent upon the system not allocating anything
> further after that, but it seems safest. The worst case is finding the
> firmware writing over bits of the kernel.

Actually, with UEFI impl. f*ckup like that, I'd rather kick it back to
the curb and simply not init runtime services instead of fixing stuff
around it. SetVirtualAddressMap in itself is a f*ckup as it is already.

Oh well, let's see what edk2 guys would say first.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
