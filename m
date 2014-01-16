Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaAPPJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:09:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:56301 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751389AbaAPPJW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:09:22 -0500
Date: Thu, 16 Jan 2014 10:09:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: pavel@pavlinux.ru
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 0/8] Linux 3.2.53-rt76-rc1
Message-ID: <20140116100921.6ecbf214@gandalf.local.home>
In-Reply-To: <52D7EE70.8000509@pavlinux.ru>
References: <20140116015824.201732155@goodmis.org>
	<52D7A93C.9090801@pavlinux.ru>
	<20140116091847.0786c8af@gandalf.local.home>
	<52D7EE70.8000509@pavlinux.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 18:36:32 +0400
Pavel Vasilyev <pavel@pavlinux.ru> wrote:

> 16.01.2014 18:18, Steven Rostedt пишет:
> > On Thu, 16 Jan 2014 13:41:16 +0400
> > Pavel Vasilyev <pavel@pavlinux.ru> wrote:
> > 
> >> 16.01.2014 05:58, Steven Rostedt пишет:
> >>> Dear RT Folks,
> >>>
> >>> This is the RT stable review cycle of patch 3.2.53-rt76-rc1.
> >>
> >> Yap..., mainline is 3.2.54 !
> >>
> > 
> > Yeah, but I already had the -rt specific changes merged into 3.2.53
> > before 3.2.54 was released, and then I discovered the cpu hotplug bug.
> > I did not want to release that -rc until it was solved. Now that it is,
> > I can release this one and then move to 3.2.54.
> 
> 
> $ xz -cd /tmp/patch-3.2.53-rt75-rt76-rc1.patch.xz | patch -p1 --dry-run
> 
> checking file arch/arm/kernel/smp_tlb.c
> checking file arch/tile/include/asm/smp.h
> checking file arch/tile/kernel/smp.c
> checking file drivers/net/wireless/orinoco/orinoco_usb.c
> checking file drivers/usb/gadget/f_fs.c
> checking file drivers/usb/gadget/inode.c
> checking file fs/buffer.c
> checking file include/linux/smp.h
> Hunk #1 succeeded at 117 with fuzz 1 (offset 16 lines).
> Hunk #2 FAILED at 147.
> 1 out of 2 hunks FAILED
> checking file include/linux/spinlock_rt.h
> checking file kernel/cpu.c
> checking file kernel/rtmutex.c
> checking file kernel/smp.c
> Hunk #1 FAILED at 712.
> 1 out of 1 hunk FAILED
> checking file kernel/softirq.c
> checking file kernel/timer.c
> checking file localversion-rt
> 
> 
> include/linux/smp.h REJECT: #define on_each_cpu_mask() and #define
> on_each_cpu_cond() and same in kernel/smp.c
> 
> 

Ouch, thanks for letting me know. I'll give it a try to make sure that
the patch is the same code that I tested.

-- Steve
