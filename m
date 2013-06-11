Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3FKRfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:35:55 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:53032 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3FKRfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130611170249.GA1091@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<20130611170249.GA1091@linux.vnet.ibm.com>
Date: Tue, 11 Jun 2013 10:35:53 -0700
X-Google-Sender-Auth: Mq0ci6vgsWKgBcASGFW2qfMzHKU
Message-ID: <CA+55aFw5d7X0YrgbnQ3Z3iUPir6AvEF0KsAL2T2dQL4V+LnnXA@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] v2 Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?B?6LWW5rGf5bGx?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>,
        Michel Lespinasse <walken@google.com>,
        Waiman Long <waiman.long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Something just struck me when reading this patch..

Our memory ordering semantics in our *current* locks are very very
subtle. We have just a "barrier()" between the

    inc.head = ACCESS_ONCE(lock->tickets.head);
    if (inc.head == inc.tail)
        break; /* success */

and the inside of the locked region.

I think it's safe because of the new memory ordering semantics (loads
are in-order, and stores only move *down*), but there's not even a
comment about it.

So let's at least comment the current locks before making them even
more complex and subtle..

              Linus
