Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3FYVt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:49:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:59333 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3FYVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:49:55 -0400
Date: Tue, 25 Jun 2013 23:49:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/8] Provide infrastructure for full-system
 idle
In-Reply-To: <20130625213721.GA19452@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1306252345210.4013@ionos.tec.linutronix.de>
References: <20130625213721.GA19452@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Paul E. McKenney wrote:
> Note that this version pays attention to CPUs that have taken an NMI
> from idle.  It is not clear to me that NMI handlers can safely access
> the time on a system that is long-term idle.  Unless someone tells me
> that it is somehow safe to access time from an NMI from idle, I will
> remove NMI support in the next version.

NMI cannot access any time related functions independent of NOHZ, long
term idle or whatever you come up with:

       write_seqcount_begin(&timekeeper_seq);

---> NMI
	...
	do {
	   seq = read_seqcount_begin(&timekeeper_seq);
	} while (read_seqcount_retry(&timekeeper_seq, seq));

Guess how well that works ....

Thanks,

	tglx
