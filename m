Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaBUWLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:11:50 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:47983 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaBUWLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:11:49 -0500
Date: Fri, 21 Feb 2014 17:13:50 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cc'ing x32 people

On Fri, 21 Feb 2014, Vince Weaver wrote:

> So I'm not sure who exactly to report this to.  Some perf people CC'd as
> I trigger it while using the perf_fuzzer.
> 
> This is with 3.14-rc3 on a core2 machine, although I've had the reboots 
> happen throughout at least 3.14-rc*
> 
> I'm having a hard time coming up with a reproducible test case.  Using the 
> random seed that caused the below will cause the perf_fuzzer to segfault 
> but not reboot.
> 
> The log isn't very helpful, it reboots so fast that the oops doesn't 
> finish printing and the serial log just moves to the bootloader...
> 
> [ 4466.804123] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
> [ 4466.808014] IP: [<ffffffff81111783>] cache_reap+0x5e/0x1c5
> [ 4466.808014] PGD 0 
> [ 4466.808014] Oops: 0000 [#1] GNU GRUB  version 2.00-17

Maybe related, this is on an x32-compiled binary.

When trying to reproduce the perf_fuzzer myseriously segfaults on what 
appears to be perfectly valid mmap'd perf ring-buffers.

(running under gdb)

Program received signal SIGSEGV, Segmentation fault.
0x0041efbb in __memset_sse2 ()

=> 0x0041efbb <+2203>:  movdqa %xmm0,(%rdi)

rdi            0xf7f61000       4160098304

f7f61000-f7f72000 rw-s 00000000 00:08 4475  anon_inode:[perf_event]

So I'm not sure if somehow something is wrong with the page mapping, that 
makes a valid write fail and sometimes (possibly due to address space 
randomization) reboot the system?

Vince

