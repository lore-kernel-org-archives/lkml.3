Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaA2AUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:20:52 -0500
Received: from one.firstfloor.org ([193.170.194.197]:36084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaA2AUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 19:20:50 -0500
Date: Wed, 29 Jan 2014 01:20:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20140129002048.GE11821@two.firstfloor.org>
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com>
 <1390933151-1797-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390933151-1797-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So the 1-2 threads case is the standard case on a small
system, isn't it? This may well cause regressions.

> In the extremely unlikely case that all the queue node entries are
> used up, the current code will fall back to busy spinning without
> waiting in a queue with warning message.

Traditionally we had some code which could take thousands
of locks in rare cases (e.g. all locks in a hash table or all locks of
a big reader lock) 

The biggest offender was the mm for changing mmu 
notifiers, but I believe that's a mutex now.
lglocks presumably still can do it on large enough
systems.  I wouldn't be surprised if there is 
other code which e.g. make take all locks in a table.

I don't think the warning is valid and will
likely trigger in some obscure cases.

-Andi
