Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaHLLLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:11:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48723 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbaHLLLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:11:09 -0400
Date: Tue, 12 Aug 2014 12:10:30 +0100
From: Will Deacon <will.deacon@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, David Herrmann <dh.herrmann@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/2] asm-generic: add memfd_create system call to unistd.h
Message-ID: <20140812111030.GK29013@arm.com>
References: <1407764228-7904-1-git-send-email-will.deacon@arm.com>
 <CANq1E4Q0gDaJ5XGnkoCQsG8xLh1Q-EBErtEVPpeeZgGj+Nr8dQ@mail.gmail.com>
 <20140811171511.GF8828@arm.com>
 <201408112057.01177.arnd@arndb.de>
 <CAMuHMdWZ30ZKO2ddh8whmw5ThrKZC0wsU+rhgoc8fRZni0Zduw@mail.gmail.com>
 <20140812102734.GG29013@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812102734.GG29013@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 11:27:34AM +0100, Will Deacon wrote:
> On Mon, Aug 11, 2014 at 08:37:41PM +0100, Geert Uytterhoeven wrote:
> > On Mon, Aug 11, 2014 at 8:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Monday 11 August 2014, Will Deacon wrote:
> > >> On Mon, Aug 11, 2014 at 05:54:08PM +0100, David Herrmann wrote:
> > >> > On Mon, Aug 11, 2014 at 3:37 PM, Will Deacon <will.deacon@arm.com> wrote:
> > >> > > Commit 9183df25fe7b ("shm: add memfd_create() syscall") added a new
> > >> > > system call (memfd_create) but didn't update the asm-generic unistd
> > >> > > header.
> > >> > >
> > >> > > This patch adds the new system call to the asm-generic version of
> > >> > > unistd.h so that it can be used by architectures such as arm64.
> > >> > >
> > >> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > >> > > Cc: David Herrmann <dh.herrmann@gmail.com>
> > >> > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > >> >
> > >> > Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> > >>
> > >> Thanks, David.
> > >>
> > >> Arnd: shall I take this via the arm64 tree, or do you already have some
> > >> asm-generic patches queued?
> > >
> > > Please take it for arm64, I don't have any other patches queued at the moment
> > > and am currently on vacation.
> > 
> > Thanks, I was just going to look into adding it...
> > 
> > BTW, another one sneaked in: kexec_file_load. I say "sneaked", as
> > scripts/checksyscalls.sh doesn't catch it, due to it being wired up on
> > amd64 only.
> 
> Oh, well spotted!
> 
> > Will, you can please add that one, too, while you're at it?
> 
> Sure, I'll add an extra patch and repost.

Hmm, so whilst I can easily wire-up the new syscall, it's pretty useless for
anybody other than x86 at the moment. There are a bunch of arch helpers:

 arch_kexec_kernel_image_probe
 arch_kexec_kernel_verify_sig
 arch_kexec_kernel_image_load
 arch_kimage_file_post_load_cleanup

which are only implemented for x86 (arch/x86/kernel/machine_kexec_64.c),
even though I don't really see what makes them arch-specific as opposed to
file format specific.

So this syscall will always fail with -ENOEXEC at the moment. Is it still
worth wiring it up?

Will
