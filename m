Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab3CYRMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:12:18 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:61835 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab3CYRMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:12:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130325170257.GA24554@linux.vnet.ibm.com>
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
	<20130324081701.GA13328@gmail.com>
	<CAFTL4hx4FLaRR6i9ap9UrCZY4ikhVtLfUqWSsjTpsO3dvShUjQ@mail.gmail.com>
	<20130325170257.GA24554@linux.vnet.ibm.com>
Date: Mon, 25 Mar 2013 18:12:12 +0100
Message-ID: <CAFTL4hwRoMGpS823ZD51sw=+AX7_GfroPqz=EspNAtkA86YZ_g@mail.gmail.com>
Subject: Re: [GIT PULL] nohz: Full dynticks base interface
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/25 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Sun, Mar 24, 2013 at 03:46:40PM +0100, Frederic Weisbecker wrote:
>> 2013/3/24 Ingo Molnar <mingo@kernel.org>:
>> >
>> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >
>> >> Hi Ingo,
>> >>
>> >> This settles the initial ground to start a special full dynticks tree in -tip
>> >> that we can iterate incrementally to accelerate the development.
>> >> It is based on tip:sched/core.
>> >>
>> >> I tried to rearrange a bit the naming. We are probably not yet done with
>> >> that but I guess we can fix it along with the rest.
>> >>
>> >> Please pull from:
>> >>
>> >> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>> >>       full-dynticks-for-mingo
>> >>
>> >> Changes on these commits since they were part of 3.9-rc1-nohz1:
>> >>
>> >> * Force a timekeeping CPU over the full dynticks range
>> >> * Rename CONFIG_NO_HZ_FULL to CONFIG_NO_HZ_EXTENDED
>> >> * Following *_nohz_extended_* APIs renames
>> >> * Handle CPU hotplug for timekeeping
>> >> * Rename full_nohz= kernel parameter to nohz_extended=
>> >
>> > Note that boot parameters suck for pretty much any purpose but quirks -
>> > please also add a (default off!) Kconfig option to easily enable
>> > nohz_extended for all CPUs.
>> >
>> > That way I will be able to test it automatically via randconfig and such.
>>
>> Sure, I'm adding such an option.
>
> Hmmm...  This would be an option to make all but one CPU an adaptive-ticks
> CPU, right?  If so, this leads to the question of whether I should add a
> matching no-CBs Kconfig option.  My guess is "no", because the existing
> CONFIG_RCU_NOCB_CPU_ALL should work just fine -- there would be a CPU that
> was not an adaptive-ticks CPU, but does have its RCU callbacks offloaded.
>
> Or am I missing something here?

No that looks right. Now I wonder if I should select
CONFIG_RCU_NOCB_CPU_ALL at the same time. Probably.
