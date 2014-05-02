Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaEBE50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 00:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaEBE5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 00:57:25 -0400
Date: Fri, 2 May 2014 00:56:40 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        davidlohr@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.15-rc3] rtmutex-debug assertion.
Message-ID: <20140502045640.GA27264@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
	davidlohr@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
References: <20140429151655.GA14277@redhat.com>
 <20140430001432.GA32142@redhat.com>
 <alpine.DEB.2.02.1404301113110.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404301113110.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:13:57AM +0200, Thomas Gleixner wrote:
 > On Tue, 29 Apr 2014, Dave Jones wrote:
 > > This is trickier to reproduce than it first seemed, as logging slows
 > > things down so much.  But after a few hours, it logged that the
 > > call that triggered this was..
 > > 
 > > futex(uaddr=0x7f55ff8c4000, op=0x6, val=0x200000006223800b, utime=0x7f55ff8c4000, uaddr2=0x7f55ff8c4000, val3=-123)
 > > 
 > > Those addresses come from an mmap we made on startup..
 > > 
 > > [init] mapping[3]: (zeropage PROT_READ | PROT_WRITE) 0x7f55ff8c4000 (1MB)
 > > 
 > > op = FUTEX_LOCK_PI
 > > 
 > > val seems to be garbage.
 > > 
 > > I'll do another run, just to see if it's always the same set of values,
 > > but it's going to probably take an overnight run.
 > 
 > Do you have the full fuzzing log, so I can see what happened
 > before/around that?

This is tough, because it takes a long time to reproduce when the
logging is enabled, and that ends up generating a lot of output.
I've tried to cut it down some using just 4 threads, but that's
still over 30M of logs.
http://www.codemonkey.org.uk/junk/futex.tar.xz

In this run, child0 was the pid that faulted.
You can see the last line in trinity-child0.log has a similar
fingerprint to the trace above.

One thing that does look suspicious, is that all 4 threads were doing
op=0x6 right before the kernel went south.

Hope this helps.

	Dave

