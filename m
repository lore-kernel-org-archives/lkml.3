Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaL1HUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 02:20:31 -0500
Received: from dsl-pw-ha2.btc-net.bg ([212.39.90.102]:51778 "HELO
	dsl-pw-ha2.btc-net.bg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751249AbaL1HUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 02:20:30 -0500
From: =?koi8-r?B?8MzBzcXOIPDF1NLP1w==?= <plamen@petrovi.no-ip.info>
To: "'Juergen Gross'" <jgross@suse.com>, <linux-kernel@vger.kernel.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>
References: <000001d01f10$85f506f0$91df14d0$@petrovi.no-ip.info> <549EB88D.20403@suse.com>
In-Reply-To: <549EB88D.20403@suse.com>
Subject: RE: [BISECTED] 3.19-rc1 regression - kernel does not load in GRUB 0.97 (GRUB Legacy)
Date: Sun, 28 Dec 2014 09:20:17 +0200
Message-ID: <000301d0226e$bb275b50$317611f0$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQG2suHKZrsvgDolBSLOqRRrV87A3wFfzhn6nMxvygA=
Content-Language: bg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Juergen Gross [mailto:jgross@suse.com]
> Sent: Saturday, December 27, 2014 3:48 PM
> To: Пламен Петров; linux-kernel@vger.kernel.org
> Cc: 'Thomas Gleixner'
> Subject: Re: [BISECTED] 3.19-rc1 regression - kernel does not load in GRUB
> 0.97 (GRUB Legacy)
> 
> On 12/24/2014 01:28 AM, Пламен Петров wrote:
> > Hello!
> >
> > I use GRUB Legacy bootloader (version 0.97) on a couple machines, and
> > where 3.18.x loads fine, 3.19-rc1 does not.
> >
> > While compiling I used the attached .config file accompanied by "make
> > olddefconfig"
> 
> Can you tell me something about the hardware (processor model)?
> You are not booting the system under VMWare by any chance?

As a matter of fact - I am compiling in a VMware Player (6.0.3
build-1895310) virtual machine, boot testing there, and then if everything
is OK, I transfer the monolithic kernel produced on 3 virtual machines that
run on EXSi and 2 actual servers. So along those lines - the failing
3.19-rc1 never saw actual hardware - it was all tested (and bisected) inside
a VM.

> 
> Could you try the earlyprintk kernel option (serial or vga)?

Does not help. You see - the kernel never makes it there to print anything. 
GRUB just says: 

kernel /vmlinuz.test rw root=/dev/sda2 console=ttyS0,9600n8 console=tty0
            [Linux-bzImage, setup=0x3c00, size=0x430ec0]

early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.

and it just stays there.

Retyping the above here got me thinking - is early console part of the
kernel?

> 
> Can you boot with kernel option "nopat"?

Same as above - kernel command line options do not help, as they never get
into play to even make a difference.

If you need the actual details of my setup or want me to try patches - just
ask.

> 
> Juergen
> 
> > The bisection I ran points to:
> > bd809af16e3ab1f8d55b3e2928c47c67e2a865d2 is the first bad commit
> > commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
> > Author: Juergen Gross <jgross@suse.com>
> > Date:   Mon Nov 3 14:02:03 2014 +0100
> >
> >      x86: Enable PAT to use cache mode translation tables
> >

Anyway, thanks to all the devs for their changes in 3.19-rc1 - there is a
huge difference in loading speed in my compile VM: with 3.18.x there is
something like 60 seconds until the VM is up and running; and with 3.19-rc1
(with commit bd809af16e3ab1f8d55b3e2928c4 reverted) - that same machine is
up and running in less than 10 seconds.
So  that makes it a 6-fold loading time speedup from just going to 3.19-rc1.
Thanks!
---------------------------------
Plamen Petrov

