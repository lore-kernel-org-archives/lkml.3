Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaD3Drd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 23:47:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaD3Dra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 23:47:30 -0400
Date: Tue, 29 Apr 2014 23:40:23 -0400
From: Dave Jones <davej@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de
Subject: Re: [3.15-rc3] rtmutex-debug assertion.
Message-ID: <20140430034023.GA12319@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Davidlohr Bueso <davidlohr@hp.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
	Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de
References: <20140429151655.GA14277@redhat.com>
 <20140430001432.GA32142@redhat.com>
 <1398824670.2522.19.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398824670.2522.19.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 07:24:30PM -0700, Davidlohr Bueso wrote:

 > > futex(uaddr=0x7f55ff8c4000, op=0x6, val=0x200000006223800b, utime=0x7f55ff8c4000, uaddr2=0x7f55ff8c4000, val3=-123)
 > 
 > Perhaps because of chance. Even for pi futexes, if the lock is
 > uncontended, the kernel will never take part.

Ok, once more..

futex(uaddr=0x25fe000[page_rand], op=0x6, val=0xffff4e2644b3dfcb, utime=0x25fe004[page_rand], uaddr2=0x25fe008[page_rand], val3=0xffffffff440fcd80)

FUTEX_LOCK_PI again.

 > Would reverting commit c365c292d059 (sched: Consider pi boosting in
 > setscheduler()) fix this?

I'll try and write a standalone reproducer in the morning.
Then I'll be able to tell you for sure if that commit is good/bad.

	Dave

