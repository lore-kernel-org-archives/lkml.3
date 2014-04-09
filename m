Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbaDIPjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:39:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50312 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933770AbaDIPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:39:26 -0400
Date: Wed, 9 Apr 2014 11:39:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Whitehead <tedheadster@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20140409113923.7dcaf183@gandalf.local.home>
In-Reply-To: <20140409113143.6174143f@gandalf.local.home>
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
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 11:31:43 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Hmm, looking at the code, I see it probably should still do the check.
> 
> OK, nevermind ;-)

Reading even more of the code, now I'm totally confused :-)

When tick_setup_sched_timer() is called, if tick_nohz_enabled is set,
then we set tick_nohz_active.

This gets called by hrtimer_switch_to_hres(), and before that is
called, the tick_check_oneshot_changed() will never get to the
tick_nohz_switch_to_nohz() call.

Looks to me, the real answer is to nuke both the if statement *and* the
setting of the tick_nohz_active in that function. Both looks a bit
redundant to me.

-- Steve
