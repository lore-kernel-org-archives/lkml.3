Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaGXEYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:24:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51736 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaGXEYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:24:07 -0400
Message-ID: <1406175844.5094.57.camel@marge.simpson.net>
Subject: Re: [PATCH tip/core/rcu] Do not keep timekeeping CPU tick running
 for non-nohz_full= CPUs
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Date: Thu, 24 Jul 2014 06:24:04 +0200
In-Reply-To: <20140723160238.GC23175@localhost.localdomain>
References: <20140719165350.GA18411@linux.vnet.ibm.com>
	 <20140719180120.GA20887@localhost.localdomain>
	 <20140720114759.GO8690@linux.vnet.ibm.com> <20140720221245.GA2138@lerouge>
	 <20140721155922.GX8690@linux.vnet.ibm.com>
	 <20140723160238.GC23175@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 18:02 +0200, Frederic Weisbecker wrote:

> Yes. Distros seem to want to make full dynticks available for users but they
> also want the off case (when nohz_full= isn't passed) to keep the lowest overhead
> as possible.

Yup, zero being the _desired_ number.  The general case can't afford any
fastpath cycles being added by a fringe feature, we're too fat now.

Imagines marketeer highlighting shiny new fringe feature: "...and most
network benchmarks show that we only lost a few percent throughput, so
you won't have to increase the size of your server farm _too_ much".

Ok, so my imagination conjured up a _stupid_ marketeer, you get it ;-)

-Mike

