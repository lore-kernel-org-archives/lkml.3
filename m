Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3HCBJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:09:26 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36600 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab3HCBJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:09:24 -0400
MIME-Version: 1.0
In-Reply-To: <1375480258.32254.24.camel@deadeye.wl.decadent.org.uk>
References: <1375480258.32254.24.camel@deadeye.wl.decadent.org.uk>
Date: Sat, 3 Aug 2013 09:09:22 +0800
Message-ID: <CAEwRVpPdWLoZHq6Q94zVoPwG65e=TVUR6HyUJ1ZyvL6+8oCpgw@mail.gmail.com>
Subject: Re: Linux 3.2.50
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org, lwn@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,


On Sat, Aug 3, 2013 at 5:50 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> I'm announcing the release of the 3.2.50 kernel.
>
> All users of the 3.2 kernel series should upgrade.
>
> The updated 3.2.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git
>
> The diff from 3.2.49 is attached to this message.
>
> Ben.
>
> ------------
>
>  Makefile                                        |   2 +-
>  arch/powerpc/include/asm/module.h               |   5 +-
>  arch/powerpc/kernel/vmlinux.lds.S               |   3 -
>  arch/sparc/kernel/asm-offsets.c                 |   2 +
>  arch/sparc/mm/hypersparc.S                      |   8 +-
>  arch/sparc/mm/init_64.c                         |   9 +-
>  arch/sparc/mm/swift.S                           |   8 +-
>  arch/sparc/mm/tlb.c                             |   2 +-
>  arch/sparc/mm/tsunami.S                         |   6 +-
>  arch/sparc/mm/viking.S                          |  10 +-
>  drivers/acpi/acpi_memhotplug.c                  |   1 +
>  drivers/ata/ata_piix.c                          |   2 +-
>  drivers/block/xen-blkback/blkback.c             |  13 +-
>  drivers/block/xen-blkback/common.h              |   2 +
>  drivers/block/xen-blkback/xenbus.c              |   2 +
>  drivers/gpu/drm/radeon/radeon_combios.c         | 159 ++++++++----------------
>  drivers/net/dummy.c                             |   4 +
>  drivers/net/ethernet/atheros/atl1e/atl1e_main.c |  50 +++++++-
>  drivers/net/ethernet/renesas/sh_eth.c           |  17 +--
>  drivers/net/ethernet/renesas/sh_eth.h           |   2 +-
>  drivers/net/ethernet/sun/sunvnet.c              |   2 +
>  drivers/net/ifb.c                               |   8 +-

I am getting the following error while trying to compile for 32bit in
Scientific Linux 6.4:

drivers/net/ifb.c: In function 'ifb_init_module':
drivers/net/ifb.c:298: error: implicit declaration of function 'cond_resched'
make[2]: *** [drivers/net/ifb.o] Error 1

Missing include of linux/sched.h in drivers/net/ifb.c file?

I tried the following patch and it does compile successfully:

--- a/drivers/net/ifb.c    2013-08-03 04:15:12.000000000 +0800
+++ b/drivers/net/ifb.c 2013-08-03 08:43:29.040492584 +0800
@@ -34,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
+#include <linux/sched.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>


FYI and comment please.

Thanks.

Kindest regards,
Giam Teck Choon
P.S. Resend due to vger.kernel.org is rejecting due to not in plain
text.  Sorry for this duplicate sending.
