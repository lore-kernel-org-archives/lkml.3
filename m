Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894Ab3GaVvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:51:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42584 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760796Ab3GaVvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:51:32 -0400
Date: Wed, 31 Jul 2013 23:51:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Corrupted EFI region
Message-ID: <20130731215130.GA6087@pd.tnic>
References: <20130731205431.GG4724@pd.tnic>
 <20130731205858.GA1678@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130731205858.GA1678@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 09:58:58PM +0100, Matthew Garrett wrote:
> On Wed, Jul 31, 2013 at 10:54:31PM +0200, Borislav Petkov wrote:
> 
> >  efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
> >  efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
> >  efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
> > -efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
> > +efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)
> >  efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
> >  efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
> >  efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
> 
> Are we making any EFI calls in between?

Probably.

> I certainly wouldn't expect the memory map to change after
> ExitBootServices, but up until that point the firmware's free to mess
> with it.

Well, we call ExitBootServices pretty early in exit_boot().

But the problem is, something messes up the upper boundary of the region
and it is an EFI_BOOT_SERVICES_DATA region which we need for the runtime
services mapping and if we can't map it properly, we're probably going
to miss functionality or not have runtime at all.

I hope this is an edk2 only bug. Btw, I'm not running the latest version
so the hope that it could've been fixed in the meantime is not dead yet.

:)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
