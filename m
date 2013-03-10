Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3CJXxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 19:53:38 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:49719 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3CJXxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 19:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130309082650.GA9944@gmail.com>
References: <1362790259-7837-1-git-send-email-fweisbec@gmail.com>
	<20130309082650.GA9944@gmail.com>
Date: Mon, 11 Mar 2013 00:53:35 +0100
Message-ID: <CAFTL4hxt5y2hdh0_LNA-08+jNTYwkjeg=QHBfgNf_X_XCHie1w@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.9-rc1-nohz1
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/9 Ingo Molnar <mingo@kernel.org>:
> We could certainly start tip:sched/dynticks (or tip:timers/dynticks) to accelerate
> the upstream merging of it. Nobody expressed deep concerns with the approach, so
> what is left is some more hard work.

Great to see you're ok with that direction! I'm working on that then.

>
> Two quick requests:
>
>  - Mind adding a Documentation/... file with a high level description,
>    rough design, open problems, etc.?

Sure! We'll maintain that along the way.

>
>  - Please outline how the current TODO entries affect upstream
>    mergability. Does it reduce the 'full'-ness of this dynticks mode?
>    Outright buggy behavior? Other trade-offs?

Mostly this is about upstream features that won't be working with the
current state of the art: enqueuing a posix cpu timer on a nohz CPU
may result in it being ignored by the target due to the lack of
ticking until expiration, perf events may not be round-robined, etc...
I'll make sure to document all these items.

Thanks.
