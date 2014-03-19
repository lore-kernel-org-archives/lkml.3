Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbaCSVsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:48:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbaCSVsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:48:11 -0400
Date: Wed, 19 Mar 2014 22:47:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: dafreedm@gmail.com
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Consistent kernel oops with 3.11.10 & 3.12.9 on Haswell CPUs...
In-Reply-To: <20140318184909.GA26255@ofan>
Message-ID: <Pine.LNX.4.64.1403192239560.5202@axis700.grange>
References: <20140318184909.GA26255@ofan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:yBxIjJQNX4Ul1BJU0at5yC6XnI4XOMeQsg7qOnaXc1x
 1R8t2U/ZjOytmkoJKocYGJS/lgy75ZZGHRAkF9FO96Fu3aEh6K
 E2sVC9R/jwqqU4xULjuZdMno0sZV35O2o/fvAZJ1P1L6uxeI8h
 /oYYoJNHx1qPbKvHVhzgRkGLMYGi/fvRocrEhVcix2NxUG0N4+
 9cWUrgA5lBpLXnFLTSdQ9Ew6Dagb5QydwZEe7ihwzP7MGzsfNr
 Vrn7QpYi37e1UdFksRcIEH0W3xyZ37BDqJwovT5h4NntoYZWnc
 j+1PerIZc0LZSwxFahNZ4ZPR93fpm8jYKDWOFekDEPx3a0wE7V
 WcfRb/2o92sEN842a0KWtoNGy/jBOsO9mRzoC0H0UWz4SGl7ty
 U3UnJXd1F57lQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, 18 Mar 2014, dafreedm@gmail.com wrote:

> First-time poster to LKML, though I've been a Linux user for the past
> 15+ years.  Thanks to you all for your collective efforts at creating
> such a great (useful, stable, etc) kernel...
> 
> Problem at hand: I'm getting consistent kernel oops (at times,
> hard-crashes) on two of my identical servers (they are much more
> common on one of the servers than the other, but I see them on both).
> Please reference the kernel log messages appended to this email [1].

No, unfortunately I won't be able to help directly, mostly just CC-ing 
X86 maintainers. Personally, what I would do, I would first not report any 
Oopses or warnings after the kernel has already been tainted - probably by 
a previous Oops. Secondly, I would try to exclude modules from 
configurations and see, whether Oopses still occur, e.g. is dm-crypt 
always in use when you get Oopses or you can reproduce them without 
encryption?

Thanks
Guennadi

> Though at times the oops occur even when the system is largely idle,
> they seem to be exacerbated by md5sum'ing all files on a large
> partition as part of archive verification --- say 1 million files
> corresponding to 1 TByte of storage.  If I perform this repeatedly,
> the machines seem to lock up about once a week.  Strangely, other
> typical high-load/high-stress scenarios don't seem to provoke the oops
> nearly so much (see below).
> 
> Naturally, such md5sum usage is putting heavy load on the processor,
> memory, and even power supply, and my initial inclination is generally
> that I must have some faulty components.  Even after otherwise
> ambiguous diagnostics (described below), I'm highly skeptical that
> there's anything here inherent to the md5sum codebase, in particular.
> However, I have started to wonder whether this might be a kernel
> regression...
> 
> For reference, here's my setup:
> 
>   Mainboard:  Supermicro X10SLQ
>   Processor:  (Single-Socket) Intel Haswell i7-4770S (65W max TDP)
>   Memory:     32GB Kingston DDR3 RAM (4x KVR16N11/8)
>   PSU:        SeaSonic SS-400FL2 400W PSU
>   O/S:        Debian v7.4 Wheezy (amd64)
>   Filesystem: Ext4 (with default settings upon creation) over LUKS
>   Kernel:     Using both:
>                 Linux 3.11.10 ('3.11-0.bpo.2-amd64' via wheezy-backports)
>                 Linux 3.12.9 ('3.12-0.bpo.2-amd64' via wheezy-backports)
> 
> To summarize where I am now: I've been very extensively testing all of
> the likely culprits among hardware components on both of my servers
> --- running memtest86 upon boot for 3+ days, memtester in userspace
> for 24 hours, repeated kernel compiles with various '-j' values, and
> the 'stress' and 'stressapptest' load generators (see [2] for full
> details) --- and I have never seen even a hiccup in server operation
> under such "artificial" environments --- however, it consistently
> occurs with heavy md5sum operation, and randomly at other times.
> 
> At least from my past experiences (with scientific HPC clusters), such
> diagnostic results would normally seem to largely rule out most
> problems with the processor, memory, mainboard subsystems.  The PSU is
> often a little harder to rule out, but the 400W Seasonic PSUs are
> rated at 2--3 times the wattage I should really need, even under peak
> load (given each server's single-socket CPU is 65W at max TDP, there
> are only a few HDs and one SSD, and no discrete graphics at all, of
> course).
> 
> I'm further surprised to see the exact same kernel-crash behavior on
> two separate, but identical, servers, which leads me to wonder if
> there's possibly some regression between the hardware (given that it's
> relatively new Haswell microcode / silicon) and the (kernel?)
> software.
> 
> Any thoughts on what might be occurring here?  Or what I should focus
> on?  Thanks in advance.
> 
> 
> 
> [1] Attached 'KernelLogs' file.
> [2] Attached 'SystemStressTesting' file.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
