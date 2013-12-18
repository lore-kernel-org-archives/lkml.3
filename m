Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3LRS7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:59:19 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:40152 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3LRS7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:59:16 -0500
Date: Wed, 18 Dec 2013 10:59:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, aswin@hp.com,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] qrwlock: A queue read/write lock implementation
Message-ID: <20131218185910.GS19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
 <1385147087-26588-2-git-send-email-Waiman.Long@hp.com>
 <20131217192128.GA15969@linux.vnet.ibm.com>
 <52B1ED2D.3020000@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B1ED2D.3020000@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121818-0928-0000-0000-000004908833
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 01:45:01PM -0500, Waiman Long wrote:
> On 12/17/2013 02:21 PM, Paul E. McKenney wrote:

[ . . . ]

> >>+	signal_next(lock,&node);
> >Good, this allows multiple readers to acquire the lock concurrently,
> >give or take memory latency compared to critical-section duration.
> >When the first writer shows up, it presumably spins on the lock word.
> >
> 
> Yes, that was the intention. The first writer that shows up will
> block succeeding readers from getting the lock.
> 
> BTW, what was the status of the TSO memory barrier patch? This patch
> has some partial dependency it.

I am hoping that it makes it into -tip soon, as I also have a patch that
depends on it.

							Thanx, Paul

