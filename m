Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbaDIQPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:15:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58601 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933812AbaDIQPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:15:32 -0400
Date: Wed, 9 Apr 2014 12:15:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Whitehead <tedheadster@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20140409121522.50ccee9a@gandalf.local.home>
In-Reply-To: <CAKohpok8e9MoWFeNquMreRR8dbBP-_9CDP7=xdOwAwWv87VZAQ@mail.gmail.com>
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
	<CAKohpok8e9MoWFeNquMreRR8dbBP-_9CDP7=xdOwAwWv87VZAQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 21:26:51 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:


> When HRES isn't enabled and NOHZ isn't enabled as well, in that
> case we should stick to the periodic code from tick-common.c and
> the oneshot options of tick_nohz_switch_to_nohz() or
> hrtimer_switch_to_hres() shouldn't be used. And so, we still need
> those checks, as per my understanding. :)

The one thing we can agree on is that the current code is wrong :-)

> 
> Lets see what others have for this discussion :)

Yeah, those that actually wrote this code should have a say in this.

-- Steve
