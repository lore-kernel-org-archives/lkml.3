Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaFRQxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:53:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:42370 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753598AbaFRQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:53:11 -0400
Date: Wed, 18 Jun 2014 12:53:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140618125307.3994b701@gandalf.local.home>
In-Reply-To: <20140618164359.GA18598@redhat.com>
References: <20140611175934.GA28912@redhat.com>
	<20140611195613.GM4581@linux.vnet.ibm.com>
	<20140612172844.GA15795@redhat.com>
	<20140612203518.GZ4581@linux.vnet.ibm.com>
	<alpine.DEB.2.10.1406122337060.5170@nanos>
	<20140612222748.GF4581@linux.vnet.ibm.com>
	<20140612231944.GA30683@linux.vnet.ibm.com>
	<20140613150830.GB31794@redhat.com>
	<20140615054058.GJ4581@linux.vnet.ibm.com>
	<20140617185755.GA8600@linux.vnet.ibm.com>
	<20140618164359.GA18598@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 18:43:59 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

 
> And (contrary to what I said initially) we can rely on this because -rt
> converts spinlock_t into rt_mutex ?

Correct. Because if spinlock_t has this behavior, rt_mutex must have it
too, otherwise -rt will suffer greatly from that. Who knows, maybe this
will fix some strange bug reports that we have had in the past.

-- Steve
