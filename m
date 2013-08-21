Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3HURZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:25:20 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53394 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3HURZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:25:14 -0400
Date: Wed, 21 Aug 2013 12:25:11 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] Get rid of SUBARCH
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>,
        Linux-Arch <linux-arch@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
In-Reply-To: <CAMuHMdWk-EPTNmPB1O1+F7YVQLjhQsFJznYwA3t6UCGUU1T9PQ@mail.gmail.com>
	(from geert@linux-m68k.org on Wed Aug 21 07:07:33 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377105911.2737.94@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 07:07:33 AM, Geert Uytterhoeven wrote:
> On Wed, Aug 21, 2013 at 10:19 AM, Richard Weinberger <richard@nod.at>  
> wrote:
> > This series is an attempt to remove the SUBARCH make parameter.
> > It as introduced at the times of Linux 2.5 for UML to tell the UML
> > build system what the real architecture is.
> >
> > But we actually don't need SUBARCH, we can store this information
> > in the .config file.
> 
> Haha, now you have OS_ARCH (shouldn't that be called HOST_ARCH?)  
> instead,
> which is available only for UM?
> 
> > The series touches also m68k, sh, mips and unicore32.
> > These architectures magically select a cross compiler if ARCH !=  
> SUBARCH.
> > Do really need that behavior?
> 
> This does remove functionality.
> It allows to build a kernel using e.g. "make ARCH=m68k".

   make ARCH=m68k CROSS_COMPILE=m68k-
   make ARCH=arm CROSS_COMPILE=armv5l-
   make ARCH=sparc CROSS_COMPILE=sparc-
   make ARCH=ppc CROSS_COMPILE=powerpc-
   make ARCH=sh CROSS_COMPILE=sh4-
   make ARCH=mips CROSS_COMPILE=mipsel-
   make ARCH=x86 CROSS_COMPILE=i686-
   make ARCH=alpha CROSS_COMPILE=alpha-

Works the same way on all the targets I've tried so far. You specify  
the architecture, you specify the cross compiler prefix, you feed it a  
config file, you build.

(If a target supplies its own default cross compiler prefix I just have  
to override it with what mine's called anyway...)

> Perhaps this can be moved to generic code? Most (not all!)  
> cross-toolchains
> are called $ARCH-{unknown-,}linux{,-gnu}.
> Exceptions are e.g. am33_2.0-linux and bfin-uclinux.

The linaro toolchain is arm-linux-gnueabihf- and the one on kernel.org  
is arm-unknown-linux-gnueabi- and the one I build is armv5l- (because  
the FSF's  
$ARCH-unknown-gnu-format-tuple-all-hail-stallman-gnu-gnu-gnu-dammit-gcc  
is just nuts: why would I say -linux- in a linux-to-linux toolchain? Do  
windows toolchains say -windows-?)

Other toolchain sources use other prefixes (-unknown- is often  
-$VENDORNAME-), and then of course there's llvm... which is why you  
specify CROSS_COMPILE= on the make command line.

Rob