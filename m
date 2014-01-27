Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaA0SYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:24:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:53148 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753719AbaA0SYN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:24:13 -0500
Date: Mon, 27 Jan 2014 13:24:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: pavel@pavlinux.ru
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
Message-ID: <20140127132411.6f420c8f@gandalf.local.home>
In-Reply-To: <52E62A05.7080802@pavlinux.ru>
References: <20140125134519.GA9845@linutronix.de>
	<52E57D42.60206@pavlinux.ru>
	<52E61C52.6070104@linutronix.de>
	<52E62A05.7080802@pavlinux.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014 13:42:29 +0400
Pavel Vasilyev <pavel@pavlinux.ru> wrote:

> 27.01.2014 12:44, Sebastian Andrzej Siewior пишет:
> > On 01/26/2014 10:25 PM, Pavel Vasilyev wrote:
> >> 25.01.2014 17:45, Sebastian Andrzej Siewior пишет:
> >>> Dear RT folks!
> >>
> >>
> >> Gentlemen, let's have a month of stress testing! Divide tasks
> >> testing subsystem: USB, NET, MM, ACPI, AUDIO, VIDEO By CPUs:
> >> ARM/PPC/X86/X86_64...
> >>
> >> Purely on observations noted that in September 2013, the quality
> >> and stability of the code has deteriorated dramatically.
> > 
> > By September 2k13, do you mean a specific v3.10-RT release?
> > 
> 
> Any after 3.2.x-rt
> 
> Maybe I'm doing something wrong, but:
> 
> 1) All kernels (3.2, 3.8, 3.12, 3.13,...) are working normally without patches;
> 
> 2) 3.2 works fine in CONFIG_PREEMPT_RT_BASE or CONFIG_PREEMPT_RT_FULL modes;
> 
> 3) 3.10 not works at all, even without -RT patches;

Please report the problems here to LKML (linux-kernel@vger.kernel.org)
to the appropriate maintainers. As well as the stable@vger.kernel.org
mailing list.

> 
> 4) 3.12 work only as CONFIG_PREEMPT_RT_BASE or CONFIG_PREEMPT_RT_FULL in
> uniprocessor mode (maxcpus=0, nosmp).  Newer patches (Oct.-Dec.) did not work,
> even in RT_BASE mode.

Does 3.12 work without the -rt patches?

> 
> Varia hardware: One Opteron 285, 2-cpus (4 cores). Six Intel Atoms devices
> kernels compiled as x86_32.

I have an intel atom dev board hanging around somewhere. I'll see if I
can test this. Can you send me your config privately.

Thanks,

-- Steve

> 
> I have my patches, but I tested both with them and without them.
> ---
> 
> Behold! 3.12.8-rt11, RT_FULL mode, kernel cmdline: init=/bin/bash
> 
> 1.
> bash: cannot set terminal process group (-1): Inappropriate ioctl for device
> bash: no job control in this shell
> 
> 2.
> in single mode: After 2 minutes timeout: see screenshot
> http://i59.fastpic.ru/big/2014/0127/bc/0f9e04536181286f820ecaae5a8481bc.jpg
> 
> 3.
> command killall -15 freezed system!
> 
> 
> Kernel compiled with debug information starts to work normally, but of course
> slower. :D
> 

