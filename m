Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3FYWQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:16:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51741 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FYWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:16:22 -0400
Date: Tue, 25 Jun 2013 15:01:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/8] Provide infrastructure for full-system
 idle
Message-ID: <20130625220152.GH3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130625213721.GA19452@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306252345210.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306252345210.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062522-4834-0000-0000-000008679212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:49:47PM +0200, Thomas Gleixner wrote:
> On Tue, 25 Jun 2013, Paul E. McKenney wrote:
> > Note that this version pays attention to CPUs that have taken an NMI
> > from idle.  It is not clear to me that NMI handlers can safely access
> > the time on a system that is long-term idle.  Unless someone tells me
> > that it is somehow safe to access time from an NMI from idle, I will
> > remove NMI support in the next version.
> 
> NMI cannot access any time related functions independent of NOHZ, long
> term idle or whatever you come up with:
> 
>        write_seqcount_begin(&timekeeper_seq);
> 
> ---> NMI
> 	...
> 	do {
> 	   seq = read_seqcount_begin(&timekeeper_seq);
> 	} while (read_seqcount_retry(&timekeeper_seq, seq));
> 
> Guess how well that works ....

Woo-hoo!!!  I will yank the NMI support on the next version.  Thank
you for the info!

							Thanx, Paul

