Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3IMJ0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:26:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42220 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3IMJ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:26:10 -0400
Date: Fri, 13 Sep 2013 11:25:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130913092553.GL31370@twins.programming.kicks-ass.net>
References: <20130911220228.GB15367@somewhere>
 <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
 <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
 <20130912143137.GA23839@somewhere>
 <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
 <20130912151102.GB23839@somewhere>
 <alpine.DEB.2.02.1309121030390.21473@gentwo.org>
 <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
 <20130912183023.GA25386@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912183023.GA25386@somewhere>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 08:30:25PM +0200, Frederic Weisbecker wrote:

> Now the issue doesn't only concern kthreads but all tasks in the system.

No, only kernel threads, all other tasks have a parent they inherit
(namespace, cgroup, affinity etc..) context from.

> If we really want to solve that race, then may be we can think of a kernel_parameter

No bloody kernel params. I'd much rather create a pointless kthread to
act as usermodehelper parent that people can set context on (move it
into cgroups, set affinity, whatever) so it automagically propagates to
all userspace helper thingies.

Is there anything other than usermodehelper we need to be concerned
with? One that comes to mind would be unbound workqueue threads. Do we
want to share the parent with usermodehelpers or have these two classes
have different parents?


