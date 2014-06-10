Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaFJSNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:13:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:28667 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750897AbaFJSNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:13:09 -0400
Date: Tue, 10 Jun 2014 14:13:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140610141306.04a4bcf3@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1406101959420.5170@nanos>
References: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
	<20140603200125.GB1105@redhat.com>
	<20140606203350.GU4581@linux.vnet.ibm.com>
	<20140608130718.GA11129@redhat.com>
	<20140609162613.GE4581@linux.vnet.ibm.com>
	<20140609181553.GA13681@redhat.com>
	<20140609142956.3d79e9d1@gandalf.local.home>
	<CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
	<20140609154114.20585056@gandalf.local.home>
	<alpine.DEB.2.10.1406101051210.3830@nanos>
	<20140610165704.GA3110@redhat.com>
	<alpine.DEB.2.10.1406101959420.5170@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 20:08:37 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:


> > Perhaps it could simply do ->owner = RT_MUTEX_HAS_WAITERS to make this more
> > clear...
> 
> Good point. The new owner can cleanup the mess.
>  

I thought about this too. It should work with the added overhead that
every time we go into the unlock slow path, we guarantee that the next
lock will go into the lock slowpath.

As long as the new acquired lock does a fast unlock, then we get out of
this spiral.

-- Steve
