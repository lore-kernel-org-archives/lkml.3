Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3LBQCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:02:12 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:61033 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3LBQCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:02:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAA_L7Z76=97VL5jnjW_1=9vLiKVOYDzs4W0XUw0tW9UDVeKm0A@mail.gmail.com>
References: <CAA_L7Z76=97VL5jnjW_1=9vLiKVOYDzs4W0XUw0tW9UDVeKm0A@mail.gmail.com>
Date: Mon, 2 Dec 2013 11:02:10 -0500
X-Google-Sender-Auth: vNB2zga733Rxqh3tbF31fqzuZJ4
Message-ID: <CA+5PVA6ngjQPvMjzc3DcbOJXRavqk=pzdvTYUyZ9-W+bHDyNrQ@mail.gmail.com>
Subject: Re: vboxhost fails to build on 3.13
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Souvik Banerjee <souvik1997@gmail.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 1:17 PM, Souvik Banerjee <souvik1997@gmail.com> wrote:
> When I run `dkms install vboxhost/4.3.2` it fails to build with the
> following error:
> -----------------------------------------------------------------------------------------
>
> DKMS make.log for vboxhost-4.3.2 for kernel
> 3.13.0-1git-00096-g711197a-dirty (x86_64)
> Thu Nov 28 11:54:10 CST 2013
> make: Entering directory '/usr/src/linux-3.13.0-1git-00096-g711197a-dirty'
>   LD      /var/lib/dkms/vboxhost/4.3.2/build/built-in.o
>   LD      /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/built-in.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/linux/SUPDrv-linux.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/SUPDrv.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/SUPDrvSem.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/SUPDrvTracer.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/alloc-r0drv.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/initterm-r0drv.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/memobj-r0drv.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/mpnotification-r0drv.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/powernotification-r0drv.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/assert-r0drv-linux.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/alloc-r0drv-linux.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/initterm-r0drv-linux.o
>   CC [M]  /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.o
> /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.c:
> In function ‘rtR0MemObjNativeMapUser’:
> /var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.c:1539:26:
> error: ‘struct mm_struct’ has no member named ‘numa_next_reset’
>                  pTask->mm->numa_next_reset = jiffies + 0x7fffffffffffffffUL;
>                           ^
> scripts/Makefile.build:308: recipe for target
> '/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.o'
> failed
> make[2]: *** [/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv/r0drv/linux/memobj-r0drv-linux.o]
> Error 1
> scripts/Makefile.build:455: recipe for target
> '/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv' failed
> make[1]: *** [/var/lib/dkms/vboxhost/4.3.2/build/vboxdrv] Error 2
> Makefile:1253: recipe for target
> '_module_/var/lib/dkms/vboxhost/4.3.2/build' failed
> make: *** [_module_/var/lib/dkms/vboxhost/4.3.2/build] Error 2
> make: Leaving directory '/usr/src/linux-3.13.0-1git-00096-g711197a-dirty'
> -----------------------------------------------------------------------------------------
>
> It seems that numa_next_reset was removed. Using `git log -p` I think
> the offending commit is this:
>
> -----------------------------------------------------------------------------------------
>
> commit 930aa174fcc8b0efaad102fd80f677b92f35eaa2
> Author: Mel Gorman <mgorman@suse.de>
> Date:   Mon Oct 7 11:29:37 2013 +0100
>
>     sched/numa: Remove the numa_balancing_scan_period_reset sysctl

Then vboxhost needs to be modified to work with the newer kernel.
That's what happens when they keep the drivers out-of-tree.  You
should report the issue to the vbox people as they're the only ones in
a position to actually fix their driver.

josh
