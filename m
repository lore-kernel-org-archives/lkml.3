Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaKDT7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:59:22 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47567 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaKDT7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:59:19 -0500
Date: Tue, 4 Nov 2014 19:59:14 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        paulus@samba.org, mpe@ellerman.id.au,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, eiko.carstens@de.ibm.com,
        linux390@de.ibm.com, cmetcalf@tilera.com,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, dave.long@linaro.org,
        Christoph Hellwig <hch@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC PATCH] make CONFIG_STRICT_DEVMEM a core non-debug feature
Message-ID: <20141104195914.GY22224@bivouac.eciton.net>
References: <1415121836-16241-1-git-send-email-leif.lindholm@linaro.org>
 <CAGXu5jL1BBAvoxVqFa1YHJSMCbGdLiPey-dyC15YKVPB2xGfig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL1BBAvoxVqFa1YHJSMCbGdLiPey-dyC15YKVPB2xGfig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:43:00AM -0800, Kees Cook wrote:
> > diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> > index efefd12..39f7817 100644
> > --- a/drivers/char/Kconfig
> > +++ b/drivers/char/Kconfig
> > @@ -6,6 +6,22 @@ menu "Character devices"
> >
> >  source "drivers/tty/Kconfig"
> >
> > +config STRICT_DEVMEM
> > +       bool "Reduced access to /dev/mem"
> > +       depends on HAVE_ARCH_RESTRICTED_DEVMEM
> > +       default y
> > +       help
> > +         If this option is disabled, you allow userspace (root) access to all
> > +         of memory, including kernel and userspace memory. Accidental
> > +         access to this is obviously disastrous, but specific access can
> > +         be used by people debugging the kernel.
> > +
> > +         If this option is switched on, the /dev/mem file restricts userspace
> > +         access to an architecture-specific subset of the physical address
> > +         space.
> 
> Great consolidation, thanks! I would probably expand this help text a
> bit to include some of details mentioned in the x86 portion of the
> option. For example:
> 
> 
> If this option is switched on, the /dev/mem file restricts userspace
> access to an architecture-specific subset of the physical address
> space. For example on x86, PCI space and BIOS code and data
> regions. This is sufficient for things like dosemu and non-KMS
> Xorg and all common users of /dev/mem.

I considered doing that, but didn't want to risk listing too many
details of one architecture, and too few of others.

One alternative would be to add a devmem.txt somewhere in
Documentation, listing the behaviours on different architectures (this
would also be a good place to describe restrictions on types of
mappings and suchlike). The help message could then contain a mention
of that file. Would that work for you?

I really don't have a strong opinion however, and would be happy to go
along with whatever the most people would like to see.

/
	Leif
