Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaHLX6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 19:58:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41225 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaHLX6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 19:58:03 -0400
Date: Tue, 12 Aug 2014 16:57:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 0/16] RCU-tasks implementation
Message-ID: <20140812235756.GA22698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811224840.GA25594@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081223-3532-0000-0000-000003CCCFD7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 03:48:40PM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series provides v5 of a prototype of an RCU-tasks implementation,
> which has been requested to assist with tramopoline removal.  This flavor
> of RCU is task-based rather than CPU-based, and has voluntary context
> switch, usermode execution, and the idle loops as its only quiescent
> states.  This selection of quiescent states ensures that at the end
> of a grace period, there will no longer be any tasks depending on a
> trampoline that was removed before the beginning of that grace period.
> This works because such trampolines do not contain function calls,
> do not contain voluntary context switches, do not switch to usermode,
> and do not switch to idle.

[ . . . ]

> o	There are probably still bugs.

And there probably are, but this version passes 10-hour rcutorture tests
in a few configurations, so getting reasonably robust.

							Thanx, Paul

