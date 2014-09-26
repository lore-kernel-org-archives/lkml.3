Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaIZSGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:06:55 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37233 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbaIZSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:06:52 -0400
Date: Fri, 26 Sep 2014 11:06:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-next@vger.kernel.org,
        Eric Paris <eparis@redhat.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2] next: openrisc: Fix build
Message-ID: <20140926180647.GA8498@roeck-us.net>
References: <1411747539-28308-1-git-send-email-linux@roeck-us.net>
 <5425A7B5.10209@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5425A7B5.10209@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 07:51:49PM +0200, Jonas Bonn wrote:
> On 09/26/2014 06:05 PM, Guenter Roeck wrote:
> > openrisc:defconfig fails to build in next-20140926 with the following error.
> >
> > In file included from arch/openrisc/kernel/signal.c:31:0:
> > ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
> > ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared
> >
> > Fix by moving EM_OPENRISC to include/uapi/linux/elf-em.h.
> >
> > Fixes: ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
> > Cc: Eric Paris <eparis@redhat.com>
> > Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v2: Only move EM_OPENRISC.
> >
> > Another possible solution for the problem would be to include asm/elf.h
> > in arch/openrisc/kernel/signal.c. I had actually submitted a patch with
> > that fix back in August (maybe that is where I remembered the problem from).
> > Wonder what happened with that patch.
> >
> > Would it make sense to drop EM_OR32 and replace it with EM_OPENRISC where
> > it is used ? binutils seems to suggest that EM_OPENRISC is the "official"
> > definition.
> 
> Do we even use EM_OR32?  Will the kernel build with the old toolchain if
> we drop it?  If yes, drop it altogether... I don't recall the details as
> to why we kept that define around at all.  And really, why bother
> supporting the old toolchain at all... it's been at least two or three
> years since EM_OPENRISC was added, hopefully people have moved on.  If
> users want to upgrade their kernel, they can update the toolchain, too,
> at this point.
> 
EM_OR32 is used to define ELF_ARCH, which per its comment is used in core
dumps. No idea if that is important/relevant. You tell me ;-).

The kernel builds with both the old (or32) and new (or1k) toolchain after
removing EM_OR32 and defining ELF_ARCH as EM_OPENRISC. I can not test the
kernel built with the or32 toolchain, but qemu is happy with the image built
using the or1k toolchain.

I'll be happy to submit a patch to remove EM_OR32 if it is not needed anymore.

Thanks,
Guenter
