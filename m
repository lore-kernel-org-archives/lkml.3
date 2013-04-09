Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936398Ab3DIJNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:13:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53598 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935411Ab3DIJNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:13:14 -0400
Message-ID: <1365498784.2609.165.camel@laptop>
Subject: Re: [PATCH 1/7] sched: Update rq clock on nohz CPU before migrating
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Date: Tue, 09 Apr 2013 11:13:04 +0200
In-Reply-To: <1365266760-24725-2-git-send-email-fweisbec@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
	 <1365266760-24725-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-06 at 18:45 +0200, Frederic Weisbecker wrote:
> Because the sched_class::put_prev_task() callback of rt and fair
> classes are referring to the rq clock to update their runtime
> statistics. A CPU running in tickless mode may carry a stale value.
> We need to update it there.

I'm failing to see how tickless makes a difference here.. we should
never rely on a ->clock set at the last tick, that's wrong.

So either explain which/how clock update gets lost by tickless or make
it unconditional.

