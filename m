Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbaDJPnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:43:31 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58191 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454AbaDJPn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 10 Apr 2014 09:43:07 -0600
Message-ID: <CAErSpo4fUW24ShdyMHq_4CUk_EeK=uJiOTB+5fN1Ztr3cFW3hA@mail.gmail.com>
Subject: Re: hpsa driver bug crack kernel down!
To: Baoquan He <bhe@redhat.com>
Cc: storagedev@hp.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 8:39 PM, Baoquan He <bhe@redhat.com> wrote:
> Hi,
>
> The kernel is 3.14.0+ which is pulled just now.
>
>
> [   18.402695] systemd[1]: Set hostname to
> <hp-sl4545g7-01.rhts.eng.bos.redhat.com>.
> [   18.408456] random: systemd urandom read with 70 bits of entropy
> available
> [   18md[1]: Expecting device
> dev-mapper-rhel_hp\x2d\x2dsl4545g7\x2d\x2d01\x2droot.device...
>          Expecting device
> dev-mapper-rhel_hp\x2d\x2dsl4545g7\...droot.device...
> [   18.860704] systemd[1]: Starting -.slice.
> [  OK  ] Created slice -.slice.
> [   18.866030] systemd[1]: Created slice -.slice.
> [   18.869466] systemd[1]: Starting System Slice.
> [  OK  ] Created slice System Sl       18.939116] systemd[1]: Created
> slice System Slice.
> [   18.976213] systemd[1]: Starting Slices.
> [  OK  ] Reached target Slices.
> [   18.981154] systemd[1]: Reached target Slices.
> [   18.984183] systemd[1]: Starting Timers.
> [  OK  ] Reached target Timers.
> [   18.989161] systemd[1]: Reached target Timers.
> [   18.992004] systemd[1]: Starting Journal Socket.
> [  OK  ] Listening on Journal Socket.
> [   18.997174] systemd[1]: Listening on Journal Socket.
> [   19.000702] systemd[1]: Starting dracut cmdline hook...
>          Starting dracut cmdline hook...
> [   19.006697] systemd[1]: Started Load KernModules.
> [   19.110408] systemd[1]: Starting Setup Virtual Console...
>          Starting Setup Virtual Console...
> [   19.116652] systemd[1]: Starting Journal Service...
>          Starting Journal Service...
> [  OK  ] Started Journal Service.
> [   19.127172] systemd[1]: Started Journal Service.
> [  OK  ] Listening on udev Kernel Socket.
> [   19.141504] systemd-journald[281]: Vac[  OK  ] Listening on udev
> Control Socket.
> [  OK  ] Reached target Sockets.
>          Starting Create list of required static device nodes...rrent
> kernel...
>          Starting Apply Kernel Variables...
> [  OK  ] Reached target Swap.
> [  OK  ] Reached target Local File Systems.
> [  OK  ] Started dracut cmdline hook.
> [  OK  ] Started Setup Virtual Console.
> [  OK  ] Started Apply Kernel Variables.
> [  OK  ] Started Create list of required static device nodes ...current
> kernel.
>          Starting Create static device nodes in /dev...
>          Starting dracut pre-udev hook...
> [  OK  ] Started Create static device nodes in /dev.
> [   20.247819] device-mapper: uevent: version 1.0.3
> [   20.251101] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)
> initialised: dm-devel@redhat.com
> [  OK  ] Started dracut pre-udev hook.
>          Starting udev Kernel Device Manager...
> [   20.322923] systemd-udevd[335]: starting version 208
> [  OK  ] Started udev Kernel Device Manager.
>          Starting udev Coldplug all Devices...
>          Mounting Configuration File System...
> [  OK  ] Mounted Configuration File System.
> [  OK  ] Started udev Coldplug all Devices.
>          Starting dracut initqueue hook...
> [  OK  ][1] HP HPSA Driver (v 3.4.4-1)
> [   20.832850] hpsa 0000:05:00.0: can't disable ASPM; OS doesn't have
> ASPM control
>  Reached target System Initialization.
> [   20.875178] ACPI: PCI Interrupt Link [I0C0] enabled at IRQ 36
> [   20.909000] hpsa 0000:05:00.0: MSIX
> [   20.911586] hpsa 0000:05:00.0: Logical aborts not supported
>          [   20.916004] [drm] Initialized drm 1.1.0 20060810
> [   20.936139] hpsa 0000:05:00.0: hpsa0: <0x323b> at IRQ 73 using DAC
> [   20.956967] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [   20.956997] IP: [<ffffffffa004b97f>]
> hpsa_enter_performant_mode+0x4ff/0x580 [hpsa]
> [   20.957003] PGD 0
> [   20.957012] Oops: 0002 [#1] SMP
> [   20.957035] Modules linked in: drm(+) libata hpsa(+) i2c_core
> dm_mirror dm_region_hash dm_log dm_mod
> [   20.957046] CPU: 10 PID: 341 Comm: systemd-udevd Not tainted 3.14.0+
> #28
> [   20.957049] Hardware name: HP ProLiant SL4545 G7/, BIOS A31
> 12/08/2012
> [   20.957055] task: ffff880824191b40 ti: ffff88082309c000 task.ti:
> ffff88082309c000
> [   20.957078] RIP: 0010:[<ffffffffa004b97f>]  [<ffffffffa004b97f>]
> hpsa_enter_performant_mode+0x4ff/0x580 [hpsa]
> [   20.957083] RSP: 0018:ffff88082309da18  EFLAGS: 00010297
> [   20.957088] RAX: 0000000000000000 RBX: 000000007c000167 RCX:
> 0000000000000004
> [   20.957091] RDX: 000000000000

What happened with this original report?  This looks like a different
problem than the DMA fault reported by Davidlohr.  I'd start by
disassembling the hpsa module and matching the IP to a line.
Documentation/oops-tracing.txt might have useful tips on how to do
that.
