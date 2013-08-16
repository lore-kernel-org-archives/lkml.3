Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3HPA4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 20:56:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3HPA4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 20:56:53 -0400
Date: Thu, 15 Aug 2013 17:58:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130816005828.GC23424@kroah.com>
References: <20130813063501.728847844@linuxfoundation.org>
 <520A1D56.2050507@roeck-us.net>
 <20130813175858.GC7336@kroah.com>
 <20130813201936.GA18358@roeck-us.net>
 <CAMuHMdVetwp7r=O_svmnyHBEQzdg-OdRxRB-3TJVQeQ7KULU7g@mail.gmail.com>
 <20130813223622.GA12790@roeck-us.net>
 <CAMuHMdVsR3Af+ccWMq6aU99UUAtCXyf8Ss0fbSYw7tR_w2mwkA@mail.gmail.com>
 <520B5873.6010708@roeck-us.net>
 <20130815063648.GE25754@kroah.com>
 <520C9A57.9080400@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520C9A57.9080400@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 02:07:35AM -0700, Guenter Roeck wrote:
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
> >> 69349c2d cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile
> >> 7b91747d cris: posix_types.h, include asm-generic/posix_types.h
> >>
> >> With those three patches applied, cris targets build in 3.4.y.
> >
> > Wonderful, I've now applied all of these.
> >
> > Anything else I'm missing for 3.4?
> >
> 
> frv build in 3.4 is fixed with
> 
> b9e892f frv: Use core allocator for task_struct
> 25d0c52 frv: Use correct size for task_struct allocation
> 
> 25d0c52 must be applied first.

Where did you get those git ids from?

cce4517f33384c3794c759e206cc8e1bb6df146b is frv: Use correct size for
task_struct allocation.

c6ae063aaf3786b9db7f19a90bf4ed8aaebb7f90 is frv: Use core allocator for
task_struct.

I'll queue them up, but you might want to check your git tree...

thanks,

greg k-h
