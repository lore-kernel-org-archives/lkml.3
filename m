Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373Ab3HOGdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:33:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3HOGdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:33:02 -0400
Date: Wed, 14 Aug 2013 23:34:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130815063435.GC25754@kroah.com>
References: <20130813063501.728847844@linuxfoundation.org>
 <520A1D56.2050507@roeck-us.net>
 <20130813175858.GC7336@kroah.com>
 <20130813201936.GA18358@roeck-us.net>
 <CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:49:42PM +0200, Geert Uytterhoeven wrote:
> On Tue, Aug 13, 2013 at 10:19 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > m68k/allmodconfig:
> > drivers/hid/hid-microsoft.c: In function 'ms_report_fixup':
> > drivers/hid/hid-microsoft.c:52:18: error: macro "memcmp" passed 6 arguments, but takes just 3
> > drivers/hid/hid-microsoft.c:51:5: error: 'memcmp' undeclared (first use in this function)
> > drivers/hid/hid-microsoft.c:51:5: note: each undeclared identifier is reported only once for each function it appears in
> 
> Fixed in v3.7-rc6:
> 
> commit 6b90466cfec2a2fe027187d675d8d14217c12d82
> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Mon Nov 12 10:16:09 2012 +0100
> 
>     HID: microsoft: do not use compound literal - fix build

Now applied.

> > blackfin/defconfig:
> > ERROR: "vm_iomap_memory" [drivers/video/fb.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> >
> > sh/defconfig:
> > drivers/built-in.o: In function `fb_mmap':
> > fbmem.c:(.text+0x5e8): undefined reference to `vm_iomap_memory'
> >
> > Both look similar and might be easy to fix if someone knows what is wrong.
> 
> Fixed in v3.9:
> 
> commit 3c0b9de6d37a481673e81001c57ca0e410c72346
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Apr 27 13:25:38 2013 -0700
> 
>     vm: add no-mmu vm_iomap_memory() stub

Now applied.

> > cris/...:
> > In file included from include/linux/page-flags.h:8:0,
> >                  from kernel/bounds.c:9:
> > include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
> > include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
> > include/linux/types.h:30:1: error: unknown type name '__kernel_pid_t'
> > include/linux/types.h:31:1: error: unknown type name '__kernel_daddr_t'
> > include/linux/types.h:33:1: error: unknown type name '__kernel_suseconds_t'
> >
> > That one might be tricky (or simple if someone knows what is wrong).
> 
> Fixed in v3.5-rc1:
> 
> commit 74f077d2a7651409c44bb323471f219a4b0d2aab
> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Mon Apr 2 13:40:17 2012 +0200
> 
>     cris: posix_types.h, include asm-generic/posix_types.h

Now applied.

Thanks for digging these out.

greg k-h
