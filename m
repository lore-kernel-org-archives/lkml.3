Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaAOWdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:33:00 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51904 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaAOWcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:32:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140115122401.GB18065@localhost>
References: <20140115121201.GA16953@localhost>
	<20140115122401.GB18065@localhost>
Date: Wed, 15 Jan 2014 14:32:52 -0800
X-Google-Sender-Auth: tM_Sb4V6TYdpPGUdf3fZeSkPOU4
Message-ID: <CAGXu5jL5zZwhEtPG=-1UNJ-AgKdFNeLzk-EoYdAzjMWQbBUK4Q@mail.gmail.com>
Subject: Re: [x86, kaslr] PANIC: early exception 0e rip 10:ffffffff8ae04c6e
 error 0 cr2 ffffffff81972b28
From: Kees Cook <keescook@chromium.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 4:24 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Kees,
>
> This script can reproduce the problem. Please modify the -initrd line
> before use.
>
> Usage:
>         ./kvm-0day.sh vmlinuz-3.12.0-rc4-00008-g6e6a493
>
> #!/bin/bash
>
> kernel=$1
>
> kvm=(
>         qemu-system-x86_64 -cpu kvm64 -enable-kvm
>         -kernel $kernel
>         -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz
>         # -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz
>         # -initrd /kernel-tests/initrd/quantal-core-i386.cgz
>         # -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz
>         -smp 2
>         -m 256M
>         -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>         -net user,vlan=0
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         debug
>         sched_debug
>         apic=debug
>         ignore_loglevel
>         # dyndbg=\"func kobject_release +p\"
>         sysrq_always_enabled
>         panic=10
>         prompt_ramdisk=0
>         earlyprintk=ttyS0,115200
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
> )
>
> "${kvm[@]}" --append "${append[*]}"

Thanks! I'm using your yocto image and this script, but I still am not
encountering the problem. I'm building next-20140114 using the
randconfig you sent in the original report. It looks like you're built
against a slightly different kernel version? Is there some way you can
push the tree you're building to git somewhere for me to fetch?

-Kees


-- 
Kees Cook
Chrome OS Security
