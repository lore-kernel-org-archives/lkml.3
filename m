Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab3DYMGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:06:51 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:37509 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab3DYMGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:06:50 -0400
MIME-Version: 1.0
Date: Thu, 25 Apr 2013 14:06:48 +0200
Message-ID: <CAFTL4hxzpoy1wwmenhPaEg9tovfrXeMQ5QBC5gkW0L3z86VPAg@mail.gmail.com>
Subject: Kconfig doesn't support select on choices (was Re: [GIT PULL] nohz:
 Adaptively stop the tick, finally)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux.com>, Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/25 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> >         depends on VIRT_CPU_ACCOUNTING_GEN
>> >
>> > It should _really_ select both the RCU and the CPU time accounting model
>> > automatically!
>>
>> Yeah I know. I have yet to fix that in Kconfig (it's a Kconfig limitation).
>
> Why cannot we simply select it and its dependencies, explicitly, for the
> time being? Something like:
>
>         depends on 64BIT
>         select VIRT_CPU_ACCOUNTING
>         select VIRT_CPU_ACCOUNTING_GEN
>
> 90% of the .config's have VIRT_CPU_ACCOUNTING_GEN turned off, because it's
> a default-off feature - so dynticks-full is effectively hidden from the
> large majority of testers...

Whatever we do, it seems that select does not work with choices.

Michal, we are running into an issue where a Kconfig option needs to
select CONFIG_VIRT_CPU_ACCOUNTING_GEN but this latter option is part
of a choice menu so it doesn't work. As a result we are forced to use
a "depends on" and this hides the high level option we are interested
in (here full dynticks) behind its low level dependency. How hard do
you think it would be to fix this? I tried something that worked
half-way but I quickly got lost in the Kconfig maze.

Thanks.
