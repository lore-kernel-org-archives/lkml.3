Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967Ab3BNR2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:28:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:38831 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3BNR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:28:33 -0500
Date: Thu, 14 Feb 2013 18:28:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [-rc7 regression] Block IO/VFS/ext3/timer spinlock lockup?
In-Reply-To: <20130214150810.GA26095@gmail.com>
Message-ID: <alpine.LFD.2.02.1302141808320.22263@ionos>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com> <20130213111007.GA11367@gmail.com> <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com> <alpine.LFD.2.02.1302140012460.22263@ionos> <20130214144510.GC25282@gmail.com>
 <20130214145424.GA26071@gmail.com> <20130214150810.GA26095@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013, Ingo Molnar wrote:
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > > CPU0 appears to be idle:
> > > 
> > > [  118.510000] Call Trace:
> > > [  118.510000]  [<7900844b>] cpu_idle+0x86/0xb4
> > > [  118.510000]  [<792a91df>] rest_init+0x103/0x108
> > > [  118.510000]  [<794558cc>] start_kernel+0x2c7/0x2cc

Weird.
 
> > So, I've done a partial bisection, the breakage appears to have 
> > gone upstream between v3.8-rc3 and v3.8-rc4.
>
> these three:
> 
> 10d73e655cef mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment
> c060f943d092 mm: use aligned zone start for pfn_to_bitidx calculation
> c0232ae861df mm: memblock: fix wrong memmove size in memblock_merge_regions()
> 
> might have highmem=512m boot parameter sensitivity.

Is highmem=512 the boot parameter which makes it come and go ?

Thanks,

	tglx
