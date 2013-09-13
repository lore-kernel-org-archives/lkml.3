Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3IMPkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:40:43 -0400
Received: from a194-81.smtp-out.amazonses.com ([199.255.194.81]:8593 "EHLO
	a194-81.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592Ab3IMPkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:40:42 -0400
Date: Fri, 13 Sep 2013 15:40:40 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <alpine.DEB.2.02.1309131010480.26487@gentwo.org>
Message-ID: <0000014117fb2ea3-ec97f4c4-344b-42c5-b27c-be876f723942-000000@email.amazonses.com>
References: <20130912141625.GA23357@somewhere> <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com> <20130912143137.GA23839@somewhere> <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
 <20130912151102.GB23839@somewhere> <alpine.DEB.2.02.1309121030390.21473@gentwo.org> <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com> <20130912183023.GA25386@somewhere> <20130913092553.GL31370@twins.programming.kicks-ass.net>
 <00000141179a5b1f-b94a8394-9e98-400c-ae7f-59cdcfce60a6-000000@email.amazonses.com> <20130913144008.GF21832@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1309131010480.26487@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... usermodehelper is based on workqueues. I guess this will
ultimately come down to modify the workqueue behavior for
WORK_CPU_UNBOUND?

If WORK_CPU_UNBOUND could mean to limit process execution to the affinity
of kthreadd then we are fine.

That would also benefit many other workqueue events that may otherwise
disturb tickless cpus.



