Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbaD3JNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:13:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:48571 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaD3JNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:13:44 -0400
Date: Wed, 30 Apr 2014 11:13:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        davidlohr@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.15-rc3] rtmutex-debug assertion.
In-Reply-To: <20140430001432.GA32142@redhat.com>
Message-ID: <alpine.DEB.2.02.1404301113110.6261@ionos.tec.linutronix.de>
References: <20140429151655.GA14277@redhat.com> <20140430001432.GA32142@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Dave Jones wrote:
> This is trickier to reproduce than it first seemed, as logging slows
> things down so much.  But after a few hours, it logged that the
> call that triggered this was..
> 
> futex(uaddr=0x7f55ff8c4000, op=0x6, val=0x200000006223800b, utime=0x7f55ff8c4000, uaddr2=0x7f55ff8c4000, val3=-123)
> 
> Those addresses come from an mmap we made on startup..
> 
> [init] mapping[3]: (zeropage PROT_READ | PROT_WRITE) 0x7f55ff8c4000 (1MB)
> 
> op = FUTEX_LOCK_PI
> 
> val seems to be garbage.
> 
> I'll do another run, just to see if it's always the same set of values,
> but it's going to probably take an overnight run.

Do you have the full fuzzing log, so I can see what happened
before/around that?

Thanks,

	tglx
