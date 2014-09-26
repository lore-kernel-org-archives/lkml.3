Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaIZLfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:35:18 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:64173 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbaIZLfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:35:15 -0400
Date: Fri, 26 Sep 2014 13:35:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI urgent fixes
Message-ID: <20140926113510.GA14625@gmail.com>
References: <20140925073133.GQ18635@console-pimps.org>
 <20140925144127.GA3828@gmail.com>
 <1411730854.7866.10.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411730854.7866.10.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Bolle <pebolle@tiscali.nl> wrote:

> On Thu, 2014-09-25 at 16:41 +0200, Ingo Molnar wrote:
> > * Matt Fleming <matt@console-pimps.org> wrote:
> > 
> > > Folks,
> > > 
> > > Please consider pulling the following fixes.
> > > 
> > > The first two are releated to the bug report I got from Linus and Josh
> > > Boyer, whereby Fedora20 + grub2 systems were no longer booting. Linus
> > > reverted the offending commit that broke grub2 boot, but that left us in
> > > a state where Macbooks still didn't boot with EFI. This is fixed with
> > > the below revert and I'm dropping a noisey boot time efi_printk() based
> > > on Josh's request and Linus' OK.
> > > 
> > > The third patch fixes a 32-bit EFI boot stub bug where garbled text is
> > > displayed on the screen if any of the efi_printk() statements run.
> > > 
> > > The following changes since commit 3eddc69ffeba092d288c386646bfa5ec0fce25fd:
> > > 
> > >   x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8 (2014-09-14 15:24:31 +0100)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent
> > > 
> > > for you to fetch changes up to 115c6628a59044958c205f8468a1b3ba3d539e61:
> > > 
> > >   x86/efi: Truncate 64-bit values when calling 32-bit OutputString() (2014-09-24 21:56:46 +0100)
> > > 
> > > ----------------------------------------------------------------
> > >  * Revert the static library changes from the merge window since they're
> > >    causing issues for Macbooks and Fedora + Grub2 - Matt Fleming
> > > 
> > >  * Delete the misleading "setup_efi_pci() failed!" message which some
> > >    people are seeing when booting EFI - Matt Fleming
> > > 
> > >  * Fix printing strings from the 32-bit EFI boot stub by only passing
> > >    32-bit addresses to the firmware - Matt Fleming
> > > 
> > > ----------------------------------------------------------------
> > > Matt Fleming (3):
> > >       Revert "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
> > >       x86/efi: Delete misleading efi_printk() error message
> > >       x86/efi: Truncate 64-bit values when calling 32-bit OutputString()
> > > 
> > >  arch/x86/boot/compressed/Makefile |  3 +--
> > >  arch/x86/boot/compressed/eboot.c  | 44 +++++++++++++++++++++++----------------
> > >  arch/x86/boot/compressed/eboot.h  | 16 ++++++++++++++
> > >  arch/x86/include/asm/efi.h        | 24 ---------------------
> > >  drivers/firmware/efi/Makefile     |  2 +-
> 
> This Makefile was changed in the first patch. That became 84be880560fb
> ("Revert "efi/x86: efistub: Move shared dependencies to <asm/efi.h>""),
> which just landed in next-20140926.
> 
> It appears to have introduced a typo, because:
>     CONFIG_EFI_ARM_STUB
> 
> should probably have been:
>     CONFIG_EFI_ARMSTUB

A delta fix would be nice at this point, I've got the x86 side 
tested and besides this build bug it's ready to go to Linus.

Thanks,

	Ingo
