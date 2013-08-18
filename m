Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3HRDYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 23:24:05 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34852 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3HRDYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 23:24:03 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 20:23:51 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kevin Easton <kevin@guarana.org>
Subject: Re: [PATCH tip/core/rcu 11/11] jiffies: Avoid undefined behavior
 from signed overflow
Message-ID: <20130818032350.GO28923@leaf>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376789876-27594-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376789876-27594-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 06:37:56PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> According to the C standard 3.4.3p3, overflow of a signed integer results
> in undefined behavior.  This commit therefore changes the definitions
> of time_after(), time_after_eq(), time_after64(), and time_after_eq64()
> to avoid this undefined behavior.  The trick is that the subtraction
> is done using unsigned arithmetic, which according to 6.2.5p9 cannot
> overflow because it is defined as modulo arithmetic.  This has the added
> (though admittedly quite small) benefit of shortening two lines of code
> by four characters each.
> 
> Note that the C standard considers the cast from unsigned to
> signed to be implementation-defined, see 6.3.1.3p3.  However, on a
> two-complement system, an implementation that defines anything other
> than a reinterpretation of the bits is free come to me, and I will be

s/free come/free to come/

> happy to act as a witness for its being committed to an insane asylum.

With the typo above fixed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
