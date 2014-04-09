Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994AbaDIP44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:56:56 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52763 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869AbaDIP4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140409113923.7dcaf183@gandalf.local.home>
References: <20131113113927.GA13875@mwhitehe.csb>
	<alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
	<20131113102153.5f10e6b5@gandalf.local.home>
	<20131113103134.5b8cf02f@gandalf.local.home>
	<20131113105737.3f7a0b1b@gandalf.local.home>
	<alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
	<20131113111257.482c2955@gandalf.local.home>
	<20131113161829.GE4138@linux.vnet.ibm.com>
	<20131113112338.7d303c0f@gandalf.local.home>
	<20131113163552.GF4138@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
	<CAOh2x=koQ4tXdq5_Bi4Vbo_k1a=zosFA3e4zRJGjzysYmC-PEA@mail.gmail.com>
	<20140409103138.29be16b9@gandalf.local.home>
	<CAKohponY+4y8G875wy4GsO1hTqERc7-hYKY6uQvLn28+32VxVQ@mail.gmail.com>
	<20140409112950.7be9f8ac@gandalf.local.home>
	<20140409113143.6174143f@gandalf.local.home>
	<20140409113923.7dcaf183@gandalf.local.home>
Date: Wed, 9 Apr 2014 21:26:51 +0530
Message-ID: <CAKohpok8e9MoWFeNquMreRR8dbBP-_9CDP7=xdOwAwWv87VZAQ@mail.gmail.com>
Subject: Re: nohz problem with idle time on old hardware
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Whitehead <tedheadster@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 21:09, Steven Rostedt <rostedt@goodmis.org> wrote:
> Reading even more of the code, now I'm totally confused :-)

:)

> When tick_setup_sched_timer() is called, if tick_nohz_enabled is set,
> then we set tick_nohz_active.

correct.

> This gets called by hrtimer_switch_to_hres(), and before that is
> called, the tick_check_oneshot_changed() will never get to the
> tick_nohz_switch_to_nohz() call.

If hrtimer_switch_to_hres() is called or HRES is enabled, we will
never ever call tick_nohz_switch_to_nohz().

> Looks to me, the real answer is to nuke both the if statement *and* the
> setting of the tick_nohz_active in that function. Both looks a bit
> redundant to me.

When HRES isn't enabled and NOHZ isn't enabled as well, in that
case we should stick to the periodic code from tick-common.c and
the oneshot options of tick_nohz_switch_to_nohz() or
hrtimer_switch_to_hres() shouldn't be used. And so, we still need
those checks, as per my understanding. :)

Lets see what others have for this discussion :)
