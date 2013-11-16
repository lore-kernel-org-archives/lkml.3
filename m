Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3KPPkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 10:40:45 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:50711 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3KPPki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 10:40:38 -0500
Date: Sat, 16 Nov 2013 07:40:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 4/4] documentation: Update circular buffer
 for load-acquire/store-release
Message-ID: <20131116154032.GC4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1384560630-28719-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131116001005.GA28191@linux.vnet.ibm.com>
 <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <13351.1384603125@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13351.1384603125@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111615-1344-0000-0000-0000034EEC02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 11:58:45AM +0000, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > -		/* read index before reading contents at that index */
> 
> > -		smp_mb(); /* finish reading descriptor before incrementing tail */
> 
> I'd rather you didn't remove these comments (assuming they're correct) as
> they're pointing out the point of the example.

Ah, good point!  I have added them back just before the smp_load_acquire()
and smp_store_release(), as shown below.  Does that work?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/Documentation/circular-buffers.txt b/Documentation/circular-buffers.txt
index 15e54ff50018..88951b179262 100644
--- a/Documentation/circular-buffers.txt
+++ b/Documentation/circular-buffers.txt
@@ -200,6 +200,7 @@ The consumer will look something like this:
 
 	spin_lock(&consumer_lock);
 
+	/* Read index before reading contents at that index. */
 	unsigned long head = smp_load_acquire(buffer->head);
 	unsigned long tail = buffer->tail;
 
@@ -210,6 +211,7 @@ The consumer will look something like this:
 
 		consume_item(item);
 
+		/* Finish reading descriptor before incrementing tail. */
 		smp_store_release(buffer->tail,
 				  (tail + 1) & (buffer->size - 1));
 	}

