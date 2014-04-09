Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbaDIPes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:34:48 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55589 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbaDIPeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:34:46 -0400
MIME-Version: 1.0
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
Date: Wed, 9 Apr 2014 21:04:46 +0530
Message-ID: <CAKohpomq_5H+wV5KkmBcDbLuQCg=7s3zp-HS4TSVgx5gqJ9f6A@mail.gmail.com>
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

On 9 April 2014 21:01, Steven Rostedt <rostedt@goodmis.org> wrote:
>> Do we? This is only called by tick_check_oneshot_change() which has the
>> following:
>>
>> int tick_check_oneshot_change(int allow_nohz)
>> {
>>       struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
>>
>>       if (!test_and_clear_bit(0, &ts->check_clocks))
>>               return 0;
>>
>>       if (ts->nohz_mode != NOHZ_MODE_INACTIVE)
>>               return 0;
>>
>>       if (!timekeeping_valid_for_hres() || !tick_is_oneshot_available())
>>               return 0;
>>
>>       if (!allow_nohz)
>>               return 1;
>>
>>       tick_nohz_switch_to_nohz();
>>       return 0;
>> }
>>
>> How often does it make it to that last check?

Probably we will reach here only once per boot per cpu.

> Hmm, looking at the code, I see it probably should still do the check.

But still we need it for that one time. :)
