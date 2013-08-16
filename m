Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3HPAxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 20:53:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3HPAxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 20:53:01 -0400
Date: Thu, 15 Aug 2013 17:54:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130816005437.GB23424@kroah.com>
References: <20130813063501.728847844@linuxfoundation.org>
 <520A1D56.2050507@roeck-us.net>
 <20130813175858.GC7336@kroah.com>
 <20130813201936.GA18358@roeck-us.net>
 <CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com>
 <20130813223622.GA12790@roeck-us.net>
 <CAMuHMdVsR3Af+ccWMq6aU99UUAtCXyf8Ss0fbSYw7tR_w2mwkA@mail.gmail.com>
 <520B5873.6010708@roeck-us.net>
 <20130815063648.GE25754@kroah.com>
 <520C93E8.8080802@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520C93E8.8080802@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 01:40:08AM -0700, Guenter Roeck wrote:
> On 08/14/2013 11:36 PM, Greg Kroah-Hartman wrote:
> > On Wed, Aug 14, 2013 at 03:14:11AM -0700, Guenter Roeck wrote:
> >> On 08/14/2013 01:26 AM, Geert Uytterhoeven wrote:
> >>> On Wed, Aug 14, 2013 at 12:36 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> >>>>>> cris/...:
> >>>>>> In file included from include/linux/page-flags.h:8:0,
> >>>>>>                    from kernel/bounds.c:9:
> >>>>>> include/linux/types.h:25:1: error: unknown type name '__kernel_ino_t'
> >>>>>> include/linux/types.h:29:1: error: unknown type name '__kernel_off_t'
> >>>>>> include/linux/types.h:30:1: error: unknown type name '__kernel_pid_t'
> >>>>>> include/linux/types.h:31:1: error: unknown type name '__kernel_daddr_t'
> >>>>>> include/linux/types.h:33:1: error: unknown type name '__kernel_suseconds_t'
> >>>>>>
> >>>>>> That one might be tricky (or simple if someone knows what is wrong).
> >>>>>
> >>>>> Fixed in v3.5-rc1:
> >>>>>
> >>>>> commit 74f077d2a7651409c44bb323471f219a4b0d2aab
> >>>>> Author: Jiri Slaby <jslaby@suse.cz>
> >>>>> Date:   Mon Apr 2 13:40:17 2012 +0200
> >>>>>
> >>>>>       cris: posix_types.h, include asm-generic/posix_types.h
> >>>>>
> >>>> It does fix above error, but then there is another error:
> >>>>
> >>>>     AS      arch/cris/arch-v10/lib/checksum.o
> >>>> In file included from <command-line>:4:0:
> >>>> /home/groeck/src/linux-stable/include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
> >>>> make[1]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1
> >>>> make[1]: *** Waiting for unfinished jobs....
> >>>>     AS      arch/cris/arch-v10/lib/checksumcopy.o
> >>>> In file included from <command-line>:4:0:
> >>>> /home/groeck/src/linux-stable/include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
> >>>> make[1]: *** [arch/cris/arch-v10/lib/checksumcopy.o] Error 1
> >>>
> >>> commit 7b91747d42a1012e3781dd09fa638d113809e3fd
> >>> Author: Paul Gortmaker <paul.gortmaker@windriver.com>
> >>> Date:   Wed Apr 18 21:58:43 2012 +0200
> >>>
> >>>       cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile
> >>>
> >>
> >> Great, thanks for tracking this down.
> >>
> >> With both patches applied, we are almost there. Next error:
> >>
> >> kernel/built-in.o: In function `core_kernel_data':
> >> (.text+0x12e38): undefined reference to `_sdata'
> >> make: *** [vmlinux] Error 1
> >>
> >> This has been fixed with commit 473e162e (CRIS: Add _sdata to vmlinux.lds.S).
> >>
> >> So, in summary, we have
> >>
> >> 473e162e CRIS: Add _sdata to vmlinux.lds.S
> 
> 473e162e also fixes the cris builds in 3.0, so it might make sense to apply it there as well,
> at least if 3.0 has some lifetime left.

It's easy enough, I've queued it up now.

greg k-h
