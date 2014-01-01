Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaAAJDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 04:03:00 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47205 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaAAJCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 04:02:55 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Vi0L0 <vi0l093@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.13 <= rc6. Using USB 2.0 devices is braking the system when using "threadirqs" kernel option
Date: Wed, 01 Jan 2014 10:02:52 +0100
Message-ID: <1414256.NFIeCBzEDd@merkaba>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6-tp520; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1520159.b5POhFdaYs@xaos>
References: <1520159.b5POhFdaYs@xaos>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 31. Dezember 2013, 20:13:04 schrieb Vi0L0:
> Hi,

Hi,

> as said the problem does not occur when not using "threadirqs" kernel
> option.

Ah, thats interesting. I found SD cards via internal MMC card reader in 
ThinkPad T520 to be broken with "threadirqs" on when writing files, freezes 
mouse pointer in an instant, no Ctrl-Alt-F1, but only when on graphical 
desktop (KDE with kwin + compositing), not when on TTY1 without just kdm 
running. But also with 3.13-rc6. Maybe thats related?


Re: [REGRESSION] 3.13-rc2: locks up hard on trying to transfer a file to mmc 
based internal SD card slot [FOUND]

Message-ID: <1470750.49FZyOuFaa@merkaba>
(properly need those with FQDN?)
https://lkml.org/lkml/2013/12/31/81

> Problem:
> Connecting most of the devices to USB 2.0 port is causing instability (or
> breakage) of the whole system.

I think I didn´t try USB devices. Usually I connect harddisk via eSATA as 
thats faster than USB 2 and laptop doesn´t have USB 3 ports (well it doesn´t 
have eSATA as well and as with eSATA I can plug in USB 3 via ExpressCard).

Have a Happy New Year,
Martin

> 
> Tested on My PC:
> GNU/Linux: Arch Linux x86_64 with linux 3.13 <= rc6
> Motherboard: MSI Z77A-GD65   BIOS: 10.11 (newest)
> 
> Partialy tested on a laptop:
> GNU/Linux: Ubuntu 13.10 x86_64 with linux 3.13 rc3
> MODEL: TOSHIBA SATELLITE PRO R950
> 
> 
> My PC:
> ------
> It's easiest to notice when connecting USB mouse and starting DM/X.
> USB keyborad works fine so I'm able to login to tty and do anything there,
> but whenever I start DM/X and trying to move mouse' cursour the X freeze in
> less than 1 second. Establishing the new ssh connection then is impossible.
> Fortunatelly sometimes (but only sometimes) ssh session established before
> DM/X start is alive so I can trace whatever you need, still it's impossible
> to kill X process and perform system' reboot.
> I've tested 2 mouses with same results: A4tech X750 and Razor DeathAdder
> Also checked out 2 different DMs: KDM and GDM.
> 
> Connecting mouse to USB 3.0 port is solving the mouse' problem, but then
> other devices connected to USB 2.0 ports are causing problems - ie. using
> Logitech webcam for some short time is making KDE 4.12.0 freeze.
> 
> 
> In the attachements I'm sending my system' logs catched on 3.13 rc6 kernel.
> First log - rc6-journalctl-less-debug.log - was catched on a kernel build
> with some basic debugging enabled, while second log - rc6-journalctl-more-
> debug.tar.gz - was catched on a kernel build with much more debugging. I'm
> not sure if it will be helpfull enought. I would be happy to help more,
> just let me know what can I do since I'm no expert in such debugging...
> 
> What I believe is most relevant in the logs are those lines (taken from rc6-
> journalctl-less-debug.log, line numbers on the left):
> 
> 2105 gru 31 14:40:31 xaos systemd[1]: Started K Display Manager.
> 2106 gru 31 14:40:32 xaos kernel: usb 3-1.2: ep 82: reserve intr @ 0+8
> (0.0+1) [1/3 us] mask 1c01
> 2107 gru 31 14:40:32 xaos kernel: usb 3-1.2: link qh1-1c01/ffff8800d7cbcf00
> start 0 [1/3 us]
> 2108 gru 31 14:41:40 xaos kernel: ------------[ cut here ]------------
> 2109 gru 31 14:41:40 xaos kernel: WARNING: CPU: 7 PID: 198 at
> kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xc0()
> 2110 gru 31 14:41:40 xaos kernel: Watchdog detected hard LOCKUP on cpu 7
> 2114 gru 31 14:41:40 xaos kernel: CPU: 7 PID: 198 Comm: irq/16-ehci_hcd Not
> tainted 3.13.0-2-mainline #1
> 2162 gru 31 14:41:40 xaos kernel: INFO: rcu_preempt detected stalls on
> CPUs/tasks: { 7} (detected by 0, t=60002 jiffies, g=592, c=591, q=0)
> 2165 gru 31 14:41:40 xaos kernel: CPU: 7 PID: 198 Comm: irq/16-ehci_hcd
> Tainted: G        W    3.13.0-2-mainline #1
> 
> I'm also sending my kernel config (rc6-config.x86_64) used to catch rc6-
> journalctl-less-debug.log
> 
> 
> Laptop:
> ------
> Today I had quick access to TOSHIBA SATELLITE PRO R950 laptop, i tested how
> it's working with "threadirqs" option.
> It wasn't able to even start a DM, it was stuck before, throwing these lines
> on a tty:
> BUG: soft lockup - CPU#1 stuck for 23s! [fsck:264]
> BUG: soft lockup - CPU#3 stuck for 22s! [fsck:254]
> INFO: rcu_sched detected stalls on CPU/tasks: { 2}
> But after the reboot (without "threadirqs" it was working perfectly fine)
> there was nothing interesting in the syslog, not even one info about the
> stalls. As said I had a quick access and no time for further
> investigatiuon. In the attachement I'm sending its lsusb and lspci
> (toshiba-lspci_lsusb.txt). ATM I don't have access to this laptop.
> 
> 
> 
> I believe that this problem is much more general and touching many PCs with
> intel (and maybe also non-intel) chipsets inside.
> I wrote about this problem on linux-usb@vger.kernel.org, but I was told to
> get back here because the problem is affecting also other subsystems
> (that's why i put Mr Thomas Gleixner on the CC).
> 
> 
> BTW: Happy New Year! :-)
> 
> Regards
> Vi0L0

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
