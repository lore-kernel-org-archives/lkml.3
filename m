Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab3GLFL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 01:11:28 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:42768 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3GLFL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 01:11:27 -0400
Date: Thu, 11 Jul 2013 18:00:08 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: 3.10-rc1: commit ccdfcc398594 broke uClibc build.
To: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, dhowells@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, linux-net@vger.kernel.org
In-Reply-To: <6325.1373365553@warthog.procyon.org.uk> (from
	dhowells@redhat.com on Tue Jul  9 05:25:53 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373583608.27613.46@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 05:25:53 AM, David Howells wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > The #include <linux/kernel.h> added to include/uapi/linux/netlink.h  
> causes
> > the uClibc build to go:
> >
> > In file included from include/linux/kernel.h:4,
> >                  from include/linux/netlink.h:4,
> >                  from include/linux/rtnetlink.h:5,
> >                  from libc/inet/netlinkaccess.h:27,
> >                  from libc/inet/if_index.c:37:
> > > include/linux/sysinfo.h:8: error: expected  
> specifier-qualifier-list before
> > > '__kernel_long_t'
> > > make: *** [libc/inet/if_index.o] Error 1
> > >
> > > If I comment out that line, it builds fine. The kernel builds  
> (for my
> > > config) either way.
> 
> Comment out which line?  Line 8 of include/linux/sysinfo.h or the new  
> #include
> line?

http://landley.net/hg/aboriginal/file/1616/sources/patches/linux-fixuClibc.patch

> Also, what arch are you compiling for?

My Aboriginal Linux project does arm, mips, powerpc, sparc, sh4, x86,  
x86_64, m68k, and I'm poking at adding alpha.

I believe the uClibc build breaks in a target-independent manner. I  
just rebuilt armv5l without the patch to confirm:

   CC libc/inet/if_index.os
In file included from  
/home/landley/aboriginal/aboriginal/build/simple-cross-compiler-armv5l/include/linux/kernel.h:4,
                  from  
/home/landley/aboriginal/aboriginal/build/simple-cross-compiler-armv5l/include/linux/netlink.h:4,
                  from  
/home/landley/aboriginal/aboriginal/build/simple-cross-compiler-armv5l/include/linux/rtnetlink.h:5,
                  from libc/inet/netlinkaccess.h:27,
                  from libc/inet/if_index.c:37:
/home/landley/aboriginal/aboriginal/build/simple-cross-compiler-armv5l/include/linux/sysinfo.h:8:  
error: expected specifier-qualifier-list before '__kernel_long_t'
make: *** [libc/inet/if_index.os] Error 1
make: *** Waiting for unfinished jobs....

Rob