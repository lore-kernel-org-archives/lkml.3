Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023Ab3DINL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:11:58 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:44042 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009Ab3DINL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <1365498784.2609.165.camel@laptop>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
	<1365266760-24725-2-git-send-email-fweisbec@gmail.com>
	<1365498784.2609.165.camel@laptop>
Date: Tue, 9 Apr 2013 15:11:56 +0200
Message-ID: <CAFTL4hzEM2cSX=Y5Z5AnsK3ZdrvFEWt4WwvHxx5vt4dOoWkJkQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] sched: Update rq clock on nohz CPU before migrating tasks
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9 Peter Zijlstra <peterz@infradead.org>:
> On Sat, 2013-04-06 at 18:45 +0200, Frederic Weisbecker wrote:
>> Because the sched_class::put_prev_task() callback of rt and fair
>> classes are referring to the rq clock to update their runtime
>> statistics. A CPU running in tickless mode may carry a stale value.
>> We need to update it there.
>
> I'm failing to see how tickless makes a difference here.. we should
> never rely on a ->clock set at the last tick, that's wrong.

Ah I made that big mis-assumption then ;)

>
> So either explain which/how clock update gets lost by tickless or make
> it unconditional.

So most of those fixup need to be made unconditional I think.
